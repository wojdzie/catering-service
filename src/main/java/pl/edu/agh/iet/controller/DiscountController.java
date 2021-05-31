package pl.edu.agh.iet.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import pl.edu.agh.iet.model.DiscountDTO;
import pl.edu.agh.iet.service.DiscountService;

@Controller
@RequestMapping("/discount")
public class DiscountController {

    private final DiscountService discountService;

    public DiscountController(DiscountService discountService) {
        this.discountService = discountService;
    }

    @GetMapping
    public String discountList(Model model) {
        List<DiscountDTO> discounts = discountService.getAllDiscounts();
        model.addAttribute("discounts", discounts);
        return "discount-list";
    }

    @GetMapping("/orders/add")
    public String addDiscountForOrdersForm(Model model) {
        model.addAttribute("discount", new DiscountDTO());
        return "discount-orders-add-form";
    }

    @PostMapping("orders/add")
    public String addDiscountForOrdersSubmit(Model model, @ModelAttribute DiscountDTO discountDTO) {
        discountService.saveDiscount(discountDTO);
        return discountList(model);
    }

    @GetMapping("/amount/add")
    public String addDiscountForAmountForm(Model model) {
        model.addAttribute("discount", new DiscountDTO());
        return "discount-amount-add-form";
    }

    @PostMapping("amount/add")
    public String addDiscountForAmountSubmit(Model model, @ModelAttribute DiscountDTO discountDTO) {
        discountService.saveDiscount(discountDTO);
        return discountList(model);
    }

    @GetMapping("/remove")
    public String removeProductForm(Model model) {
        List<DiscountDTO> discounts = discountService.getAllDiscounts();
        model.addAttribute("discounts", discounts);
        model.addAttribute("discount", new DiscountDTO());
        return "discount-remove-form";
    }

    @PostMapping("/remove")
    public String removeProductSubmit(Model model, @ModelAttribute DiscountDTO discountDTO) {
        discountService.deleteDiscount(discountDTO);
        return discountList(model);
    }
}
