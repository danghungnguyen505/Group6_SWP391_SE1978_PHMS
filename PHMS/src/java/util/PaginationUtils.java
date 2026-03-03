/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
/**
 *
 * @author zoxy4
 */
public class PaginationUtils {
    public static <T> List<T> getPage(List<T> list, int page, int pageSize) {
        if (list == null || list.isEmpty()) {
            return Collections.emptyList();
        }
        int totalItems = list.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        // Validate page: không cho nhỏ hơn 1 hoặc lớn hơn tổng số trang
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        if (start > totalItems) {
            return new ArrayList<>();
        }
        return list.subList(start, end);
    }
    // Tính tổng số trang
    public static int getTotalPages(List<?> list, int pageSize) {
        if (list == null || list.isEmpty()) {
            return 0;
        }
        return (int) Math.ceil((double) list.size() / pageSize);
    }
    // Lấy số trang hợp lệ (dùng để set lại currentPage attribute nếu user nhập số quá lớn
    public static int getValidPage(int page, int totalPages) {
        if (page < 1) return 1;
        if (totalPages > 0 && page > totalPages) return totalPages;
        return page;
    }
}