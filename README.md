# COMP3020 Group 36 — integrated review project

This project preserves the supplied raw/clean snapshots and original RQ2/RQ4 submissions. It adds the text analysis, clustering, a reproducible network implementation, connected interpretation, research references and an optional one-page poster source. It is a **review build**, not a claim that all submission prerequisites are complete.

## Bắt đầu trên máy Windows/RStudio

1. Giải nén **toàn bộ** thư mục. Không mở Rmd trực tiếp bên trong ZIP. Bạn có thể lưu thư mục ở bất kỳ đâu.
2. Mở `COMP3020_Group36.Rproj`. Không tự sửa đường dẫn sang `C:/Users/...`.
3. Chọn **Session > Restart R** để kiểm tra trong phiên mới.
4. Trong Console, chạy một lần:

```r
source("install_packages.R")
```

5. Chạy phân tích và các kiểm tra:

```r
source("run_analysis.R")
source("check_project.R")
```

6. Mở `Report_Group36_Integrated.Rmd`, chọn **Knit > Knit to PDF**. Hoặc chạy:

```r
rmarkdown::render("Report_Group36_Integrated.Rmd", output_format = "pdf_document")
```

7. Nếu lỗi chỉ liên quan LaTeX, kiểm tra nội dung bằng HTML trước:

```r
rmarkdown::render("Report_Group36_Integrated.Rmd", output_format = "html_document")
```

HTML là bản kiểm tra, không thay thế PDF phải nộp. Nếu máy báo thiếu LaTeX, dùng TinyTeX đã có của bạn; chỉ cài lại khi cần. File `install_packages.R` có lệnh cài một lần. PDF dùng XeLaTeX để xử lý UTF-8. Sau khi knit, kiểm tra bảng/hình có bị tràn và tổng số trang nằm trong giới hạn môn (subject outline nêu 10–30; instructions nêu tối đa 30).

## Những gì được tính và xuất

- `outputs/tables/`: audit, từ thường gặp, dictionary và từng match, RQ2 với nguồn gốc số liệu, cụm/diagnostics/examples, mạng/centrality, liên hệ cụm–reply.
- `outputs/figures/`: hình PDF vector để dùng trong poster.
- `outputs/session_info.txt`: phiên bản R, hệ điều hành và package.
- `outputs/analysis_results.rds`: kết quả cho kiểm tra nội bộ (không cần commit).

Không tải API khi knit. Thay đổi dữ liệu có thể làm thay đổi mọi kết quả; không chỉnh CSV nền riêng lẻ giữa các thành viên.

## RQ2: bổ sung đúng file nhãn

Hiện chỉ có số đếm trong bài thành viên, chưa có nhãn từng bình luận. Mặc định chương trình tái tính đúng bảng thành viên đã báo cáo và ghi rõ nguồn gốc. Nó **không tự tạo** `verification_specific` từ từ khoá.

Khi thành viên gửi file đã gắn TRUE/FALSE:

1. Giữ ít nhất hai cột `comment_id`, `verification_specific`.
2. Đảm bảo đúng 278 ID của snapshot hiện tại, mỗi ID một dòng, không thiếu nhãn.
3. Lưu thành `data/annotations/verification_labels.csv`, UTF-8.
4. Ghi quy tắc và nguồn gốc nhãn trong `docs/CODEBOOK.md`.
5. Chạy lại phân tích. Chương trình sẽ dùng nhãn thực, không dùng bảng cũ.

`verification_labels_TEMPLATE.csv` chỉ là mẫu **trống**. Không đổi các ô trống thành FALSE. Nếu file thành viên đã có đủ cột, có thể trích xuất như sau sau khi kiểm tra tên file:

```r
member_data <- read.csv("DUONG_DAN_FILE_THANH_VIEN.csv", colClasses = "character")
write.csv(member_data[c("comment_id", "verification_specific")],
          here::here("data", "annotations", "verification_labels.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
```

Đây là bước chuyển đúng nhãn thành viên, không phải phương pháp mã hóa mới. Kiểm tra đường dẫn nguồn tại máy bạn; không đưa đường dẫn cá nhân đó vào phân tích dùng chung.

Ngay cả sau khi có nhãn, kiểm định vẫn có hạn chế về phụ thuộc bình luận/tác giả. Không viết p lớn nghĩa là “không có ảnh hưởng”.

## Thông tin cần hoàn tất trước nộp

- Điền tên và student ID của mọi thành viên, link repo trong YAML `params` của Rmd.
- Hoàn thiện `data/collection_manifest.csv`: thời gian thu thập thực, lý do chọn từng luồng, code R thu thập thực tế và giới hạn.
- Cập nhật `params$collection_note` theo bằng chứng thật. Không nhận code bổ sung mới là code đã được dùng trong quá khứ.
- Nhận nhãn RQ2 và xác nhận codebook.
- Nhóm chạy, đọc và chỉnh diễn giải; điền `docs/group_contributions.csv`.
- Khi đã hoàn tất, đặt `group_review_confirmed: true`, rồi `final_mode: true`. Chế độ final chủ động báo lỗi nếu các thông tin thiết yếu vẫn thiếu. Đây là kiểm tra hoàn thiện đầu vào, không chứng nhận điểm số hay tính hợp lệ của mọi quyết định.
- Rà poster: một trang PDF; kết quả phải nhất quán report.
- Kiểm tra người chấm mở được repo; link repo nằm trong report; nộp các PDF theo Ultra.

Chính sách trong subject outline cho phép AI hỗ trợ nhưng yêu cầu nhóm đánh giá, điều chỉnh và hiểu bài. Bản này ghi đúng phần hỗ trợ; nhóm cần phản biện kết quả và chuẩn bị Q&A toàn bộ nghiên cứu.

## Poster

Sau khi report chạy, mở `Poster_Group36.Rmd` và knit PDF. Poster dùng lại cùng code/snapshot và luôn ghi RQ2 đang dùng nhãn hay bảng tổng hợp. Mặc định có nhãn **REVIEW DRAFT**. Điền thông tin thành viên/repo và xác nhận sau khi nhóm kiểm tra. Kiểm tra thực tế chỉ có một trang; source dùng A3 landscape và ba cột, không cần cài gói poster chuyên dụng.

## GitHub: cách phối hợp vừa đủ

Một người phụ trách ghép project; thành viên RQ2/RQ4 tiếp tục phụ trách nội dung của mình. Mỗi người làm trên một nhánh (`rq2`, `rq4`, `integration`), commit thay đổi nhỏ có mô tả, rồi mở pull request. Người tích hợp kiểm tra và ghép vào `main`. Tránh hai người cùng sửa report chính hoặc dữ liệu nền một lúc.

Commit dữ liệu dùng trong bài, các script/Rmd, references, README và tài liệu quyết định. Không commit token, `.Renviron`, `.RData`, thư viện package hoặc cache. Nếu dùng `renv`, giữ `renv.lock`, `.Rprofile` khởi tạo và `renv/activate.R`; không bỏ qua toàn bộ thư mục `renv`.

README và các script giúp tái lập; lần chạy đầu trên máy nhóm cần tạo `session_info.txt`. Sau khi chạy tốt, có thể chốt package bằng `renv::init()`/`renv::snapshot()`; người khác dùng `renv::restore()`. Không tự nhận một lockfile chưa chạy là môi trường đã kiểm chứng.

Repo có thể private nếu người chấm được cấp quyền; đề yêu cầu truy cập được, không bắt buộc công khai. Một thành viên khác nên clone repo vào thư mục mới và chạy theo README trước nộp.

## Code thu thập/làm sạch bổ sung

`R/01_collect_hn.R` và `R/01_rebuild_clean.R` là triển khai mới để có thể thu thập bằng R với log. Chúng không được chạy tự động và không ghi đè bản gốc.

```r
source(here::here("R", "01_collect_hn.R"))
ids <- unique(read.csv(here::here("data", "collection_manifest.csv"),
                      colClasses = "character")$thread_id)
# Only run when the group deliberately wants a NEW snapshot:
# collect_hn(ids, here::here("data", "new_downloads", "snapshot_NEW"))
```

Để tái lập phân tích trong report, dùng snapshot đi kèm. Để chứng minh quá trình thu thập gốc đáp ứng bài, cần code/log thực tế của nhóm. Một lần tải mới không khôi phục được nội dung đã xóa hoặc chứng minh trạng thái quá khứ.

## Trạng thái kiểm tra lúc bàn giao

Đã audit CSV, kiểm tra độc lập số học RQ2, dựng lại số liệu mạng và khảo sát text/clustering bằng Python; đã rà tĩnh code R và kết nối giữa các file. **Môi trường soạn bản này không có Rscript, nên chưa chạy R, knit PDF hoặc xác nhận số trang.** Các kết quả trong report sẽ lấy từ R khi bạn chạy. Python/R có thể xử lý các khoảng cách bằng nhau trong hierarchical clustering khác nhau; không chép kết quả Python vào Rmd như thể đã chạy R.
