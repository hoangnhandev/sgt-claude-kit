# Tài liệu MCP Server và Tools

Tài liệu này liệt kê các MCP Server được cấu hình trong dự án và các Tool mà chúng cung cấp.

## 1. context7 (`@upstash/context7-mcp`)

Server này cung cấp các tool để truy xuất tài liệu thư viện lập trình cập nhật nhất cho Context7.

- **`resolve-library-id`**: Chuyển đổi tên thư viện thành ID tương thích với Context7.
- **`get-library-docs`**: Lấy tài liệu (documentation) chi tiết cho một thư viện dựa trên ID đã resolve.

## 2. playwright (`@playwright/mcp`)

Server này cho phép các agent điều khiển trình duyệt web để tự động hóa và kiểm thử.

- **`navigate`**: Điều hướng trình duyệt đến một URL.
- **`click`**: Click vào một phần tử trên trang.
- **`type`**: Nhập liệu vào trường văn bản.
- **`screenshot`**: Chụp màn hình trang web.
- **`playwright_expect_response`**: Đợi một HTTP response cụ thể.
- **`start_codegen_session`**: Bắt đầu phiên ghi lại thao tác để sinh code test.
- **`playwright_resize`**: Thay đổi kích thước viewport của trình duyệt.
- **`querySelector`**: Tìm kiếm phần tử trên trang.
- Các tool hỗ trợ automation khác như lấy nội dung trang, chạy script JavaScript.

## 3. serena (`https://github.com/oraios/serena`)

Một bộ công cụ "Coding Agent" mạnh mẽ giúp LLM thao tác với codebase như một lập trình viên thực thụ (IDE-like features).

- **`find_symbol`**: Tìm định nghĩa của một symbol trong code.
- **`find_referencing_symbols`**: Tìm tất cả các nơi tham chiếu đến một symbol.
- **`insert_after_symbol`**: Chèn code vào sau một symbol cụ thể.
- **`replace_symbol_body`**: Thay thế nội dung bên trong của một symbol.
- **`activate_project`**: Kích hoạt context cho một dự án cụ thể.
- **`check_onboarding_performed`**: Kiểm tra xem dự án đã được "onboard" (index) chưa.
- Các tool hỗ trợ semantic search và chỉnh sửa file thông minh.

## 4. memory (`@modelcontextprotocol/server-memory`)

Server này cung cấp bộ nhớ dài hạn dạng Knowledge Graph cho agent.

- **`create_entities`**: Tạo các thực thể mới trong bộ nhớ.
- **`create_relations`**: Tạo mối quan hệ giữa các thực thể.
- **`add_observations`**: Thêm thông tin quan sát được vào thực thể có sẵn.
- **`delete_relations`**: Xóa mối quan hệ giữa các thực thể.
- **`read_graph`** / **`search_nodes`**: Đọc và tìm kiếm thông tin trong knowledge graph.

## 5. zai-mcp-server (`@z_ai/mcp-server`)

Chuyên về xử lý hình ảnh, video và phân tích UI.

- **`ui_to_artifact`**: Chuyển đổi screenshot UI thành code hoặc design spec.
- **`extract_text_from_screenshot`**: OCR nâng cao để lấy text/code từ ảnh chụp màn hình.
- **`diagnose_error_screenshot`**: Phân tích ảnh chụp lỗi để tìm nguyên nhân và giải pháp.
- **`understand_technical_diagram`**: Phân tích sơ đồ kỹ thuật (UML, flowcharts, architecture).
- **`analyze_data_visualization`**: Phân tích biểu đồ và dữ liệu trực quan.
- **`ui_diff_check`**: So sánh sự khác biệt UI giữa thiết kế và thực tế.
- **`analyze_image`**: Phân tích hình ảnh tổng quát.
- **`analyze_video`**: Phân tích nội dung và ngữ cảnh video.

## 6. web-search-prime (`https://api.z.ai/api/mcp/web_search_prime/mcp`)

- **`webSearchPrime`**: Tool tìm kiếm thông tin trên web, trả về kết quả bao gồm tiêu đề, tóm tắt và link nguồn.

## 7. web-reader (`https://api.z.ai/api/mcp/web_reader/mcp`)

- **`webReader`**: Tool đọc nội dung chi tiết từ một URL cụ thể, trích xuất nội dung chính và bỏ qua các thành phần không cần thiết (quảng cáo, navigation).

## 8. shadcn (`npx shadcn@latest mcp`)

Server này kết nối AI với hệ sinh thái shadcn/ui, cho phép quản lý và cài đặt components một cách thông minh.

- **`list-components`**: Liệt kê tất cả shadcn/ui components có sẵn từ các registry.
- **`get-component-docs`**: Lấy documentation chi tiết, usage examples, TypeScript source code, và metadata của component.
- **`install-component`**: Cài đặt một hoặc nhiều shadcn/ui components vào dự án (hỗ trợ npm, pnpm, yarn, bun).
- **`list-blocks`**: Liệt kê tất cả blocks (pre-built UI sections) có sẵn.
- **`get-block-docs`**: Lấy documentation và code cho một block cụ thể.
- **`install-blocks`**: Cài đặt blocks vào dự án.
