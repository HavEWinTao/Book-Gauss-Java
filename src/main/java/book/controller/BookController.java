package book.controller;

import book.entity.Book;
import book.entity.Privilege;
import book.exception.BasicException;
import book.service.BookService;
import book.utils.ResultBody;
import book.utils.UserUtils;
import book.vo.BookSearchReqData;
import book.vo.PageRspData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * @author fanhongtao
 * 2022/10/13 20:35
 */
@RestController
@RequestMapping("/book")
public class BookController {

    @Autowired
    private BookService bookService;

    /**
     * 根据条件分页查询
     */
    @PostMapping("/search")
    public ResultBody searchByPage(@RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
                                   @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
                                   @RequestBody BookSearchReqData query) {
        UserUtils.checkPrivilege(Privilege.PRI_READ, "用户无权限查看数据");
        PageRspData<Book> pageRspData;
        if ("".equals(query.getBookName()) && "".equals(query.getBookAuthor())) {
            pageRspData = bookService.listByPage(pageNum, pageSize);
        } else {
            pageRspData = bookService.searchByPage(pageNum, pageSize, query);
        }
        return ResultBody.success("查询图书成功", pageRspData);
    }

    /**
     * 查询一本书
     */
    @GetMapping("/{id}")
    public ResultBody getOneBook(@PathVariable("id") Integer id) {
        UserUtils.checkPrivilege(Privilege.PRI_EDIT, "用户无权限查看数据");
        Book book = bookService.getById(id);
        if (book == null) {
            throw new BasicException(400, "查询图书失败");
        }
        return ResultBody.success("查询图书成功", book);
    }

    /**
     * 增加一本书
     */
    @PutMapping
    public ResultBody addBook(@RequestBody Book reqData) {
        UserUtils.checkPrivilege(Privilege.PRI_READ, "用户无权限修改数据");
        boolean flag = bookService.add(reqData);
        if (!flag) {
            throw new BasicException(400, "增加图书失败");
        }
        return ResultBody.success("增加图书成功");
    }

    /**
     * 删除一本书
     * 删除书的详情信息也在数据库中进行了实现
     */
    @DeleteMapping("/{id}")
    public ResultBody deleteBook(@PathVariable("id") Integer id) {
        UserUtils.checkPrivilege(Privilege.PRI_EDIT, "用户无权限修改数据");
        //会自动拦截异常
        boolean flag = bookService.removeById(id);
        if (!flag){
            throw new BasicException(400,"存在用户借阅该图书");
        }
        return ResultBody.success("删除图书成功");
    }

    /**
     * 修改一本书
     */
    @PostMapping
    public ResultBody editBook(@RequestBody Book reqData) {
        UserUtils.checkPrivilege(Privilege.PRI_READ, "用户无权限修改数据");
        boolean flag = bookService.updateBook(reqData);
        if (!flag) {
            throw new BasicException(400, "修改图书失败");
        }
        return ResultBody.success("修改图书成功");
    }

    /**
     * 批量上传csv
     */
    @PostMapping("/upload")
    public ResultBody upload(@RequestPart MultipartFile file) {
        UserUtils.checkPrivilege(Privilege.PRI_EDIT, "用户无权限修改数据");
        if (file == null) {
            throw new BasicException(400, "未上传文件");
        }
        int num = bookService.addAll(file);
        return ResultBody.success("上传" + num + "本书");
    }
}
