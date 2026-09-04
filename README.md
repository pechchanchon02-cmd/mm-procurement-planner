# Procurement Planner (Supabase)

เครื่องมือวางแผน+ติดตามงานจัดซื้อ แทน Nifty สำหรับ workflow สั่งใหม่/สกรีนนอก
ไฟล์เดียว `index.html` + Firebase (Firestore + Storage) · design system เดียวกับ merchmaker-stock-check

## ติดตั้ง (ครั้งเดียว ~5 นาที)
1. Supabase → SQL Editor → รัน `schema.sql` → แล้วรัน `seed.sql` (100 งาน + milestones จาก Tracking เดิม)
2. เปิด index.html → ⚙ → ใส่ Supabase URL + anon key → เลือกชื่อตัวเอง → บันทึก
3. Deploy: GitHub repo → Netlify → แชร์ URL ให้ทีม (แต่ละคนใส่ URL+key ครั้งแรกครั้งเดียว)

> RLS เปิดแบบ allow-all (internal tool) — อย่าแชร์ URL/key นอกทีม; คุมสิทธิ์จริงค่อยเพิ่ม Supabase Auth

## การใช้งาน
- ＋ เปิดงาน → พิมพ์เลขงาน (ดึงจากชีท raw อัตโนมัติ; ยังไม่มีใน raw ก็เปิดล่วงหน้าได้ ระบบเติมให้ทีหลัง)
- ตอบ 3 คำถาม (สั่งผ้าใหม่?/ตัดเย็บใหม่?/สกรีนนอก-ใน) → ได้แผน milestone ทั้งเส้น ▲▼ สลับลำดับได้
- ติ๊ก ✓ เมื่อขั้นเสร็จจริง · ซัพเป็น dropdown + เพิ่ม "อื่นๆ" ได้
- 4 หน้า: Running / ปฏิทิน / Timeline / ซัพพลายเออร์ (ตอนนี้ vs 🔜 จะเข้า + copy ข้อความ LINE)
- ต้นทุนอยู่หลังปุ่ม 💰 ในแต่ละงาน แยกจากบอร์ดทีม
- master ขั้นตอน/ซัพ default: แก้ใน Supabase → Table editor → `step_master`

## โครงข้อมูล (ตาราง)
`jobs` (ข้อมูลจาก raw) · `procurement` (flags+PIC+cost ต่องาน) · `milestones` (แผนต่อขั้น) ·
`events` (ประวัติการแก้) · `suppliers` · `step_master` · Storage bucket `job-images` (รูป)

## Roadmap
LINE แจ้งเตือนรายวัน · หน้าแก้ master ในแอป · สรุปต้นทุนรวม · lead-time จริงจาก events
