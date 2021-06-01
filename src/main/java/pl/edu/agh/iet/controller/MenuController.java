package pl.edu.agh.iet.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import pl.edu.agh.iet.model.MenuDTO;
import pl.edu.agh.iet.model.MenuSizeDTO;
import pl.edu.agh.iet.service.MenuService;

@Controller
@RequestMapping("/menu")
public class MenuController {

    private final MenuService menuService;

    public MenuController(MenuService menuService) {
        this.menuService = menuService;
    }

    @GetMapping
    public String menuList(Model model) {
        List<MenuDTO> menu = menuService.getCurrentMenu();
        model.addAttribute("menu", menu);
        return "menu-list";
    }

    @GetMapping("/generate")
    public String menuGenerateForm(Model model) {
        model.addAttribute("menuSize", new MenuSizeDTO());
        return "menu-generate";
    }

    @PostMapping("/generate")
    public String menuGenerateSubmit(Model model, @ModelAttribute MenuSizeDTO menuSizeDTO) {
        menuService.generateNewMenu(menuSizeDTO);
        return menuList(model);
    }
}
