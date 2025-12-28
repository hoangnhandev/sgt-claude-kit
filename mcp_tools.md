# Tài liệu MCP Server và Tools

Tài liệu này liệt kê các MCP Server được cấu hình trong dự án và các Tool mà chúng cung cấp.

## 1. context7 (`@upstash/context7-mcp`)

Server này cung cấp các tool để truy xuất tài liệu thư viện lập trình cập nhật nhất cho Context7.

- **`resolve-library-id`**: Chuyển đổi tên thư viện thành ID tương thích với Context7.
- **`get-library-docs`**: Lấy tài liệu (documentation) chi tiết cho một thư viện dựa trên ID đã resolve.

## 2. playwright (`@playwright/mcp`)

Server này cho phép các agent điều khiển trình duyệt web để tự động hóa và kiểm thử.

### Bộ công cụ sinh mã (Code Generation Tools)

- **`start_codegen_session`**: Bắt đầu một phiên ghi lại thao tác để sinh ra các kịch bản kiểm thử Playwright có thể tái sử dụng.
- **`end_codegen_session`**: Kết thúc phiên ghi mã và tạo file kiểm thử.
- **`get_codegen_session`**: Lấy thông tin về phiên ghi mã (bao gồm các hành động đã ghi và trạng thái).
- **`clear_codegen_session`**: Xóa phiên ghi mã mà không sinh file kiểm thử.

### Bộ công cụ điều khiển trình duyệt (Browser Automation Tools)

- **`Playwright_navigate`**: Điều hướng đến một URL với các cấu hình viewport và trình duyệt có thể tùy chỉnh (Chromium, Firefox, WebKit).
- **`Playwright_screenshot`**: Chụp ảnh màn hình toàn bộ trang hoặc các phần tử cụ thể (hỗ trợ lưu PNG hoặc chuỗi base64).
- **`Playwright_resize`**: Thay đổi kích thước viewport tại thời điểm thực thi. Hỗ trợ hơn 143+ thiết bị giả lập (iPhone, Pixel, iPad, v.v.) với user-agent và touch emulation tự động.
- **`Playwright_click`**: Nhấp vào các phần tử trên trang bằng CSS selector.
- **`playwright_click_and_switch_tab`**: Nhấp vào liên kết và chuyển sang tab mới vừa mở.
- **`Playwright_iframe_click`**: Nhấp vào các phần tử nằm bên trong một iframe.
- **`Playwright_iframe_fill`**: Điền dữ liệu vào các phần tử bên trong một iframe.
- **`Playwright_hover`**: Di chuột qua các phần tử trên trang.
- **`Playwright_fill`**: Điền dữ liệu vào các trường nhập liệu (input fields).
- **`Playwright_select`**: Chọn một giá trị từ thẻ `SELECT`.
- **`playwright_upload_file`**: Tải file lên các phần tử input có `type='file'`.
- **`Playwright_evaluate`**: Thực thi mã JavaScript trực tiếp trong console của trình duyệt.
- **`Playwright_console_logs`**: Thu thập log từ console trình duyệt (hỗ trợ lọc theo loại: error, warning, log, info, v.v.).
- **`Playwright_close`**: Đóng trình duyệt và giải phóng tài nguyên.
- **`Playwright_expect_response`**: Yêu cầu Playwright bắt đầu đợi một HTTP response khớp với URL pattern.
- **`Playwright_assert_response`**: Đợi và xác thực HTTP response đã được bắt đầu đợi trước đó (kiểm tra status code, body, v.v.).
- **`playwright_custom_user_agent`**: Thiết lập User Agent tùy chỉnh cho trình duyệt.
- **`playwright_get_visible_text`**: Lấy nội dung văn bản đang hiển thị trên trang (loại bỏ các phần tử ẩn).
- **`playwright_get_visible_html`**: Lấy nội dung HTML của trang hoặc của một container cụ thể (hỗ trợ lọc code script, comment, style, v.v.).
- **`playwright_go_back`**: Quay lại trang trước trong lịch sử trình duyệt.
- **`playwright_go_forward`**: Đi tới trang tiếp theo trong lịch sử trình duyệt.
- **`playwright_drag`**: Kéo một phần tử đến một vị trí mục tiêu.
- **`playwright_press_key`**: Nhấn một phím bàn phím (ví dụ: 'Enter', 'ArrowDown').
- **`playwright_save_as_pdf`**: Lưu trang hiện tại dưới dạng file PDF với các tùy chọn định dạng trang (A4, Letter) và lề (margins).

## 3. serena (`https://github.com/oraios/serena`)

Một bộ công cụ "Coding Agent" mạnh mẽ giúp LLM thao tác với codebase như một lập trình viên thực thụ (IDE-like features). Lưu ý rằng trong hầu hết các cấu hình, chỉ một tập hợp con của các công cụ này được kích hoạt đồng thời.

- **`activate_project`**: Kích hoạt một dự án dựa trên tên hoặc đường dẫn.
- **`check_onboarding_performed`**: Kiểm tra xem việc onboarding dự án đã được thực hiện hay chưa.
- **`create_text_file`**: Tạo/ghi đè file văn bản trong thư mục dự án.
- **`delete_lines`**: Xóa một phạm vi dòng trong file.
- **`delete_memory`**: Xóa một memory khỏi bộ nhớ của dự án.
- **`execute_shell_command`**: Thực thi lệnh shell.
- **`find_file`**: Tìm kiếm file theo đường dẫn tương đối.
- **`find_referencing_symbols`**: Tìm các symbol tham chiếu đến symbol tại vị trí đã cho.
- **`find_symbol`**: Tìm kiếm symbol toàn cục hoặc cục bộ (theo tên/substring).
- **`get_current_config`**: In cấu hình hiện tại của agent (projects, tools, contexts, modes).
- **`get_symbols_overview`**: Lấy tổng quan các top-level symbols trong file.
- **`initial_instructions`**: Hướng dẫn cách sử dụng bộ công cụ Serena.
- **`insert_after_symbol`**: Chèn nội dung sau định nghĩa của một symbol.
- **`insert_at_line`**: Chèn nội dung tại dòng cụ thể.
- **`insert_before_symbol`**: Chèn nội dung trước định nghĩa của một symbol.
- **`jet_brains_find_referencing_symbols`**: Tìm reference symbol (JetBrains context).
- **`jet_brains_find_symbol`**: Tìm kiếm symbol (JetBrains context).
- **`jet_brains_get_symbols_overview`**: Lấy tổng quan symbol (JetBrains context).
- **`list_dir`**: Liệt kê file và thư mục.
- **`list_memories`**: Liệt kê các memory trong dự án.
- **`onboarding`**: Thực hiện onboarding (nhận diện cấu trúc dự án).
- **`prepare_for_new_conversation`**: Hướng dẫn chuẩn bị cho hội thoại mới.
- **`read_file`**: Đọc file trong thư mục dự án.
- **`read_memory`**: Đọc memory theo tên.
- **`remove_project`**: Xóa dự án khỏi cấu hình.
- **`rename_symbol`**: Đổi tên symbol (refactoring).
- **`replace_lines`**: Thay thế phạm vi dòng bằng nội dung mới.
- **`replace_content`**: Thay thế nội dung file (hỗ trợ regex).
- **`replace_symbol_body`**: Thay thế toàn bộ định nghĩa của một symbol.
- **`restart_language_server`**: Khởi động lại language server.
- **`search_for_pattern`**: Tìm kiếm pattern trong dự án.
- **`summarize_changes`**: Hướng dẫn tóm tắt thay đổi.
- **`switch_modes`**: Kích hoạt các chế độ (modes).
- **`think_about_collected_information`**: Suy nghĩ về độ đầy đủ của thông tin.
- **`think_about_task_adherence`**: Suy nghĩ về việc tuân thủ nhiệm vụ.
- **`think_about_whether_you_are_done`**: Suy nghĩ xem đã hoàn thành nhiệm vụ chưa.
- **`write_memory`**: Ghi memory vào bộ nhớ dự án.

## 4. memory (`@modelcontextprotocol/server-memory`)

Server này cung cấp bộ nhớ dài hạn dạng Knowledge Graph cho agent, cho phép lưu trữ và truy xuất các thực thể và mối quan hệ giữa chúng.

- **`create_entities`**: Tạo nhiều thực thể mới trong knowledge graph. Mỗi thực thể bao gồm tên (name), loại (entityType) và các quan sát (observations). Sẽ bỏ qua nếu tên thực thể đã tồn tại.
- **`create_relations`**: Tạo nhiều mối quan hệ mới giữa các thực thể (from, to, relationType). Bỏ qua các mối quan hệ trùng lặp.
- **`add_observations`**: Thêm các quan sát mới vào các thực thể đã có sẵn. Trả về các quan sát đã thêm hoặc báo lỗi nếu thực thể không tồn tại.
- **`delete_entities`**: Xóa các thực thể và tất cả các mối quan hệ liên quan của chúng.
- **`delete_observations`**: Xóa các quan sát cụ thể khỏi thực thể.
- **`delete_relations`**: Xóa các mối quan hệ cụ thể khỏi đồ thị.
- **`read_graph`**: Đọc toàn bộ knowledge graph, trả về cấu trúc đầy đủ bao gồm tất cả thực thể và mối quan hệ.
- **`search_nodes`**: Tìm kiếm các node dựa trên truy vấn (query) tìm kiếm qua tên thực thể, loại thực thể và nội dung quan sát.
- **`open_nodes`**: Truy xuất các node cụ thể theo tên, bao gồm cả các mối quan hệ giữa chúng.

## 5. zai-mcp-server (`@z_ai/mcp-server`)

Chuyên về xử lý hình ảnh, video và phân tích UI.

- **`ui_to_artifact`**: Chuyển đổi ảnh chụp màn hình UI thành mã nguồn (code), prompt, tài liệu kỹ thuật (specs) hoặc mô tả.
- **`extract_text_from_screenshot`**: Nhận dạng ký tự (OCR) từ ảnh chụp màn hình cho mã nguồn, terminal, tài liệu và văn bản nói chung.
- **`diagnose_error_screenshot`**: Phân tích ảnh chụp lỗi và đề xuất các giải pháp khắc phục có khả năng thực thi.
- **`understand_technical_diagram`**: Diễn giải các sơ đồ kiến trúc, luồng phân tích (flow), UML, ER và sơ đồ hệ thống.
- **`analyze_data_visualization`**: Đọc hiểu các biểu đồ và dashboard để đưa ra các thông tin chuyên sâu (insights) và xu hướng.
- **`ui_diff_check`**: So sánh hai ảnh chụp UI để phát hiện sự sai lệch về mặt hình ảnh hoặc triển khai thực tế.
- **`image_analysis`**: Phân tích hình ảnh đa mục đích khi các công cụ chuyên dụng khác không phù hợp.
- **`video_analysis`**: Kiểm tra video (dung lượng ≤ 8MB; định dạng MP4/MOV/M4V) để mô tả cảnh quay, các khoảnh khắc và các thực thể xuất hiện.

## 6. web-search-prime (`https://api.z.ai/api/mcp/web_search_prime/mcp`)

- **`webSearchPrime`**: Tool tìm kiếm thông tin trên web, trả về kết quả bao gồm tiêu đề, tóm tắt và link nguồn.

## 7. web-reader (`https://api.z.ai/api/mcp/web_reader/mcp`)

- **`webReader`**: Tool đọc nội dung chi tiết từ một URL cụ thể, trích xuất nội dung chính và bỏ qua các thành phần không cần thiết (quảng cáo, navigation).

## 8. shadcn (`npx shadcn@latest mcp`)

Server này kết nối AI với hệ sinh thái shadcn/ui, cho phép quản lý và cài đặt components/blocks một cách thông minh từ các registry.

- **`get_project_registries`**: Lấy danh sách các registry được cấu hình trong dự án hiện tại.
- **`list_items_in_registries`**: Liệt kê tất cả các item (components, blocks, v.v.) có sẵn trong các registry.
- **`search_items_in_registries`**: Tìm kiếm các item cụ thể trong các registry dựa trên từ khóa.
- **`view_items_in_registries`**: Xem chi tiết mã nguồn, tài liệu và metadata của một item từ registry.
- **`get_item_examples_from_registries`**: Truy xuất các ví dụ sử dụng (usage examples) của một item để tham khảo cách triển khai.
- **`get_add_command_for_items`**: Lấy câu lệnh CLI chính xác (ví dụ: `npx shadcn@latest add ...`) để cài đặt các item đã chọn vào dự án.
- **`get_audit_checklist`**: Lấy danh sách các tiêu chuẩn kiểm tra (audit checklist) để đảm bảo component được triển khai đúng cách và tuân thủ các best practices.
