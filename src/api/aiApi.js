// api/aiApi.js
// Tích hợp AI Chat – hiện dùng mock, sẵn sàng cho Gemini API

const delay = (ms) => new Promise((r) => setTimeout(r, ms));

// Mock responses thông minh dựa trên nội dung câu hỏi
const getMockResponse = (message, context) => {
  const msg = message.toLowerCase();

  if (msg.includes('chi tiêu') || msg.includes('tháng này')) {
    const { totalIncome = 0, totalExpense = 0, topCategories = [] } = context;
    const savings = totalIncome - totalExpense;
    const savingsRate = totalIncome > 0 ? Math.round((savings / totalIncome) * 100) : 0;

    return `📊 **Phân tích tháng này của bạn:**

Dựa trên dữ liệu chi tiêu, tổng thu nhập của bạn là **${totalIncome.toLocaleString('vi-VN')}₫** và tổng chi tiêu là **${totalExpense.toLocaleString('vi-VN')}₫**.

💰 **Số dư tiết kiệm:** ${savings.toLocaleString('vi-VN')}₫ (${savingsRate}% thu nhập)

${savingsRate >= 20 ? '✅ Tỷ lệ tiết kiệm của bạn **rất tốt**! Các chuyên gia tài chính khuyến nghị tiết kiệm ít nhất 20% thu nhập.' :
  savingsRate >= 10 ? '⚠️ Tỷ lệ tiết kiệm ở mức **trung bình**. Bạn nên cố gắng cắt giảm chi tiêu để đạt 20% thu nhập.' :
  '🔴 Tỷ lệ tiết kiệm **thấp**. Cần xem xét lại ngân sách và cắt giảm các khoản không cần thiết.'}

📌 **Gợi ý:** Hãy ưu tiên quy tắc 50/30/20:
- 50% cho nhu cầu thiết yếu (ăn uống, nhà ở, đi lại)
- 30% cho nhu cầu cá nhân  
- 20% cho tiết kiệm và đầu tư`;
  }

  if (msg.includes('cắt giảm') || msg.includes('tiết kiệm')) {
    return `💡 **Gợi ý cắt giảm chi tiêu:**

1. **Ăn uống** – Hạn chế đặt đồ ăn online, nấu ăn tại nhà có thể tiết kiệm 30-40%
2. **Mua sắm** – Áp dụng quy tắc "24h": chờ 24 giờ trước khi mua đồ không cần thiết
3. **Giải trí** – Rà soát các subscription không dùng (Netflix, Spotify, gym...)
4. **Di chuyển** – Kết hợp xe buýt + grab thay vì grab toàn bộ

📌 **Nguyên tắc quan trọng:** Theo dõi chi tiêu hàng ngày giúp bạn nhận ra các khoản lãng phí nhỏ tích lũy thành số tiền lớn.`;
  }

  if (msg.includes('đầu tư') || msg.includes('tài chính')) {
    return `📈 **Lộ trình đầu tư cơ bản:**

**Bước 1:** Xây dựng quỹ khẩn cấp (3-6 tháng chi tiêu)
**Bước 2:** Trả hết nợ lãi suất cao
**Bước 3:** Bắt đầu đầu tư với rủi ro thấp:
- Gửi tiết kiệm ngân hàng (4-7%/năm)
- Trái phiếu, quỹ mở
**Bước 4:** Đa dạng hóa danh mục (chứng khoán, bất động sản...)

⚠️ **Lưu ý:** Độ an toàn tài chính quan trọng hơn lợi nhuận cao, đặc biệt khi mới bắt đầu.`;
  }

  if (msg.includes('ngân sách') || msg.includes('budget')) {
    return `📋 **Cách lập ngân sách hiệu quả:**

Tôi khuyên bạn dùng **phương pháp phong bì số** - phân bổ tiền vào từng danh mục ngay đầu tháng:

| Danh mục | Tỷ lệ đề xuất |
|---|---|
| Ăn uống | 15-20% |
| Nhà ở | 25-30% |
| Di chuyển | 5-10% |
| Sức khỏe | 5-10% |
| Giải trí | 5-10% |
| Tiết kiệm | 20%+ |

Hãy sử dụng tính năng **Ngân sách** trong ứng dụng để đặt hạn mức cho từng danh mục và theo dõi tiến độ mỗi ngày.`;
  }

  // Default response
  return `Xin chào! 👋 Tôi là trợ lý AI tài chính của bạn. Tôi có thể giúp bạn:

- 📊 **Phân tích chi tiêu** – Đánh giá tình hình tài chính tháng này
- 💡 **Gợi ý tiết kiệm** – Tìm các khoản có thể cắt giảm  
- 📈 **Tư vấn đầu tư** – Hướng dẫn bắt đầu đầu tư an toàn
- 📋 **Lập ngân sách** – Phân bổ thu nhập hợp lý

Hãy đặt câu hỏi cụ thể để tôi hỗ trợ bạn tốt nhất nhé!`;
};

/**
 * Gửi tin nhắn đến AI và nhận phản hồi
 * @param {string} message - Tin nhắn của user
 * @param {Array}  history  - Lịch sử chat
 * @param {Object} context  - Dữ liệu tài chính của user (tổng thu, chi, ...)
 */
export const sendMessageToAI = async (message, history = [], context = {}) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY;

  // ── Nếu có Gemini API key → gọi thật ──────────────────
  if (apiKey) {
    const systemPrompt = `Bạn là trợ lý AI tài chính cá nhân thông minh, thân thiện. 
Dữ liệu tài chính tháng này của người dùng:
- Tổng thu: ${(context.totalIncome || 0).toLocaleString('vi-VN')}₫
- Tổng chi: ${(context.totalExpense || 0).toLocaleString('vi-VN')}₫
- Số dư: ${((context.totalIncome || 0) - (context.totalExpense || 0)).toLocaleString('vi-VN')}₫
- Top danh mục chi tiêu: ${(context.topCategories || []).map(c => `${c.name}: ${c.amount.toLocaleString('vi-VN')}₫`).join(', ')}

Hãy trả lời bằng tiếng Việt, ngắn gọn, thực tế và có ích.`;

    const contents = [
      ...history.map((h) => ({
        role: h.role === 'user' ? 'user' : 'model',
        parts: [{ text: h.content }],
      })),
      { role: 'user', parts: [{ text: message }] },
    ];

    const res = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`,
      {
        method:  'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          system_instruction: { parts: [{ text: systemPrompt }] },
          contents,
          generationConfig: { temperature: 0.7, maxOutputTokens: 1024 },
        }),
      },
    );

    if (!res.ok) throw new Error(`Gemini API error: ${res.status}`);
    const data = await res.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || 'Xin lỗi, tôi không thể trả lời lúc này.';
  }

  // ── Không có API key → dùng mock ─────────────────────
  await delay(1200 + Math.random() * 800);
  return getMockResponse(message, context);
};
