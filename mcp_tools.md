# Tài liệu MCP Server và Tools

Tài liệu này liệt kê các MCP Server được cấu hình trong dự án và các Tool mà chúng cung cấp.

## 1. context7 (`@upstash/context7-mcp`)

Server này cung cấp các tool để truy xuất tài liệu thư viện lập trình cập nhật nhất cho Context7.

- **`resolve-library-id`**: Chuyển đổi tên thư viện thành ID tương thích với Context7.
- **`get-library-docs`**: Lấy tài liệu (documentation) chi tiết cho một thư viện dựa trên ID đã resolve.

## 2. serena (`https://github.com/oraios/serena`)

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

## 3. memory (`@modelcontextprotocol/server-memory`)

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
