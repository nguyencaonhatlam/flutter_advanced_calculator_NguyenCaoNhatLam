# 🏗 Kiến trúc hệ thống

## Tổng quan

Ứng dụng sử dụng **Provider** để quản lý state và chia module rõ ràng.

---

## Cấu trúc thư mục

```
lib/
├── models/
├── providers/
├── screens/
├── widgets/
├── utils/
├── services/
```

---

## Thành phần chính

### 1. CalculatorProvider

* Xử lý input
* Tính toán biểu thức
* Quản lý memory
* Quản lý chế độ

---

### 2. HistoryProvider

* Lưu lịch sử
* Thêm / xóa lịch sử

---

### 3. ThemeProvider

* Quản lý theme
* Lưu lựa chọn người dùng

---

## Luồng dữ liệu

UI → Provider → Logic → Result → UI

---

## State Management

* Sử dụng Provider
* Dùng ChangeNotifier
* notifyListeners() để cập nhật UI

---

## Quyết định thiết kế

* Dùng Provider vì đơn giản, dễ hiểu
* Dùng math_expressions để parse biểu thức
* Tách module để dễ mở rộng
