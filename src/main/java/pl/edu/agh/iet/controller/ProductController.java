package pl.edu.agh.iet.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import pl.edu.agh.iet.model.ProductDTO;
import pl.edu.agh.iet.model.ProductTypeDTO;
import pl.edu.agh.iet.service.ProductService;

@Controller
@RequestMapping("/product")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String productList(Model model) {
        List<ProductDTO> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "product-list";
    }

    @GetMapping("/add")
    public String addProductForm(Model model) {
        List<ProductTypeDTO> productTypes = productService.getAllProductTypes();
        model.addAttribute("productTypes", productTypes);
        model.addAttribute("product", new ProductDTO());
        return "product-add-form";
    }

    @PostMapping("/add")
    public String addProductSubmit(Model model, @ModelAttribute ProductDTO productDTO) {
        productService.saveProduct(productDTO);
        return productList(model);
    }

    @GetMapping("/remove")
    public String removeProductForm(Model model) {
        List<ProductDTO> products = productService.getAllProducts();
        model.addAttribute("products", products);
        model.addAttribute("product", new ProductDTO());
        return "product-remove-form";
    }

    @PostMapping("/remove")
    public String removeProductSubmit(Model model, @ModelAttribute ProductDTO productDTO) {
        productService.deleteProduct(productDTO);
        return productList(model);
    }
}
