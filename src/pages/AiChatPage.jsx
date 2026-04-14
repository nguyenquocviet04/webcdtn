// pages/AiChatPage.jsx
// Giao diện chat AI tư vấn tài chính (kiểu ChatGPT)

import { useState, useRef, useEffect, useMemo } from 'react';
import { Send, Bot, Sparkles, TrendingUp, RefreshCw } from 'lucide-react';
import { sendMessageToAI } from '../api/aiApi';
import useTransactionStore from '../store/transactionStore';
import { sumBy, groupBy } from '../utils/calcPercent';
import { getCategoryById } from '../constants/categories';
import { formatCurrency } from '../utils/formatCurrency';
import Button from '../components/ui/Button';
import dayjs from 'dayjs';
import toast from 'react-hot-toast';

// Gợi ý câu hỏi nhanh
const QUICK_SUGGESTIONS = [
  'Tháng này tôi chi tiêu hợp lý chưa?',
  'Tôi nên cắt giảm chi tiêu ở đâu?',
  'Gợi ý cách tiết kiệm hiệu quả hơn',
  'Tôi nên đầu tư như thế nào?',
  'Phân tích ngân sách của tôi',
  'Cách lập kế hoạch tài chính?',
];

// Render markdown đơn giản
const renderMarkdown = (text) => {
  return text
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/`(.*?)`/g, '<code class="bg-slate-100 dark:bg-slate-700 px-1 py-0.5 rounded text-xs font-mono">$1</code>')
    .replace(/\|(.+)\|/g, (row) => {
      const cells = row.split('|').filter(Boolean);
      return `<tr>${cells.map((c) => `<td class="border border-slate-200 dark:border-slate-700 px-2 py-1 text-xs">${c.trim()}</td>`).join('')}</tr>`;
    })
    .replace(/\n/g, '<br />');
};

const ChatMessage = ({ msg }) => {
  const isAI = msg.role === 'assistant';
  return (
    <div className={`flex gap-3 ${isAI ? '' : 'flex-row-reverse'} animate-slide-up`}>
      {/* Avatar */}
      <div className={`w-8 h-8 rounded-full flex-shrink-0 flex items-center justify-center ${isAI ? 'bg-gradient-to-br from-primary-500 to-primary-700' : 'bg-gradient-to-br from-slate-400 to-slate-600'}`}>
        {isAI ? <Bot className="w-4 h-4 text-white" /> : <span className="text-xs font-bold text-white">U</span>}
      </div>
      {/* Bubble */}
      <div className={`max-w-[80%] ${isAI ? '' : ''}`}>
        <div
          className={[
            'px-4 py-3 rounded-2xl text-sm leading-relaxed',
            isAI
              ? 'bg-white dark:bg-dark-800 border border-slate-100 dark:border-slate-700 text-slate-700 dark:text-slate-300 rounded-tl-sm'
              : 'bg-primary-600 text-white rounded-tr-sm',
          ].join(' ')}
          dangerouslySetInnerHTML={{ __html: renderMarkdown(msg.content) }}
        />
        <p className={`text-[10px] text-slate-400 mt-1 ${isAI ? '' : 'text-right'}`}>
          {dayjs(msg.timestamp).format('HH:mm')}
        </p>
      </div>
    </div>
  );
};

const TypingIndicator = () => (
  <div className="flex gap-3 animate-fade-in">
    <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center flex-shrink-0">
      <Bot className="w-4 h-4 text-white" />
    </div>
    <div className="bg-white dark:bg-dark-800 border border-slate-100 dark:border-slate-700 rounded-2xl rounded-tl-sm px-4 py-3">
      <div className="flex gap-1 items-center h-4">
        <div className="w-2 h-2 bg-slate-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
        <div className="w-2 h-2 bg-slate-400 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
        <div className="w-2 h-2 bg-slate-400 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
      </div>
    </div>
  </div>
);

const AiChatPage = () => {
  const { transactions } = useTransactionStore();
  const [messages, setMessages]   = useState([
    {
      id: 'welcome',
      role: 'assistant',
      content: 'Xin chào! 👋 Tôi là **FinanceAI** – trợ lý tài chính thông minh của bạn.\n\nTôi có thể giúp bạn phân tích chi tiêu, gợi ý tiết kiệm và tư vấn tài chính cá nhân. Hãy đặt câu hỏi hoặc chọn gợi ý bên dưới!',
      timestamp: new Date().toISOString(),
    },
  ]);
  const [input, setInput]         = useState('');
  const [isTyping, setIsTyping]   = useState(false);
  const messagesEndRef             = useRef(null);
  const inputRef                   = useRef(null);

  const thisMonth = dayjs().format('YYYY-MM');
  const monthTxs  = transactions.filter((t) => t.date?.startsWith(thisMonth));

  // Context tài chính để gửi cho AI
  const financialContext = useMemo(() => {
    const expTxs   = monthTxs.filter((t) => t.type === 'expense');
    const incTxs   = monthTxs.filter((t) => t.type === 'income');
    const grouped  = groupBy(expTxs, 'categoryId');
    const topCategories = Object.entries(grouped)
      .map(([catId, txs]) => ({
        name:   getCategoryById(catId).name,
        amount: sumBy(txs, 'amount'),
      }))
      .sort((a, b) => b.amount - a.amount)
      .slice(0, 5);

    return {
      totalIncome:    sumBy(incTxs, 'amount'),
      totalExpense:   sumBy(expTxs, 'amount'),
      topCategories,
    };
  }, [monthTxs]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, isTyping]);

  const sendMessage = async (text) => {
    const content = text || input.trim();
    if (!content || isTyping) return;

    const userMsg = {
      id:        `u${Date.now()}`,
      role:      'user',
      content,
      timestamp: new Date().toISOString(),
    };

    setMessages((prev) => [...prev, userMsg]);
    setInput('');
    setIsTyping(true);

    try {
      const history = messages.filter((m) => m.id !== 'welcome');
      const reply   = await sendMessageToAI(content, history, financialContext);
      setMessages((prev) => [
        ...prev,
        { id: `ai${Date.now()}`, role: 'assistant', content: reply, timestamp: new Date().toISOString() },
      ]);
    } catch {
      toast.error('Không thể kết nối AI. Vui lòng thử lại.');
    } finally {
      setIsTyping(false);
      inputRef.current?.focus();
    }
  };

  const handleAutoAnalyze = () => {
    const text = `Phân tích tình hình tài chính tháng ${dayjs().format('MM/YYYY')} của tôi:
- Tổng thu: ${formatCurrency(financialContext.totalIncome)}
- Tổng chi: ${formatCurrency(financialContext.totalExpense)}
- Top danh mục: ${financialContext.topCategories.map((c) => `${c.name} (${formatCurrency(c.amount)})`).join(', ')}
Hãy đánh giá và đưa ra gợi ý cụ thể.`;
    sendMessage(text);
  };

  const clearChat = () => {
    setMessages([{
      id: 'welcome-new',
      role: 'assistant',
      content: 'Cuộc trò chuyện mới đã bắt đầu! Tôi có thể giúp gì cho bạn? 😊',
      timestamp: new Date().toISOString(),
    }]);
  };

  return (
    <div className="flex flex-col h-[calc(100vh-var(--navbar-height)-3rem)] max-w-3xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-4 flex-shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center">
            <Bot className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-base font-bold text-slate-800 dark:text-white">AI Tư vấn tài chính</h1>
            <div className="flex items-center gap-1.5">
              <div className="w-1.5 h-1.5 rounded-full bg-income-500 animate-pulse" />
              <span className="text-xs text-slate-400">Đang hoạt động</span>
            </div>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Button
            variant="secondary" size="sm" icon={TrendingUp}
            onClick={handleAutoAnalyze}
            disabled={isTyping}
          >
            <span className="hidden sm:inline">Phân tích tháng này</span>
            <span className="sm:hidden">Phân tích</span>
          </Button>
          <Button variant="ghost" size="sm" icon={RefreshCw} onClick={clearChat} title="Xóa chat" />
        </div>
      </div>

      {/* Messages area */}
      <div className="flex-1 overflow-y-auto space-y-4 mb-4 pr-1">
        {messages.map((msg) => (
          <ChatMessage key={msg.id} msg={msg} />
        ))}
        {isTyping && <TypingIndicator />}
        <div ref={messagesEndRef} />
      </div>

      {/* Quick suggestions */}
      {messages.length <= 2 && !isTyping && (
        <div className="flex flex-wrap gap-2 mb-3 flex-shrink-0">
          {QUICK_SUGGESTIONS.map((s) => (
            <button
              key={s}
              onClick={() => sendMessage(s)}
              className="px-3 py-1.5 bg-white dark:bg-dark-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs text-slate-600 dark:text-slate-400 hover:border-primary-300 hover:text-primary-600 transition-all"
            >
              {s}
            </button>
          ))}
        </div>
      )}

      {/* Input area */}
      <div className="flex-shrink-0 card p-3">
        <div className="flex items-end gap-3">
          <textarea
            ref={inputRef}
            rows={1}
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
              }
            }}
            placeholder="Hỏi tôi về tài chính của bạn... (Enter để gửi)"
            className="flex-1 resize-none input-base py-2.5 max-h-32 overflow-y-auto"
            style={{ minHeight: '42px' }}
          />
          <Button
            onClick={() => sendMessage()}
            disabled={!input.trim() || isTyping}
            loading={isTyping}
            icon={Send}
            className="flex-shrink-0"
          >
            Gửi
          </Button>
        </div>
        <p className="text-[10px] text-slate-400 mt-2 text-center">
          AI có thể mắc lỗi. Hãy xác minh thông tin quan trọng với chuyên gia tài chính.
        </p>
      </div>
    </div>
  );
};

export default AiChatPage;
