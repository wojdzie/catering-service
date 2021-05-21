package pl.edu.agh.iet.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import pl.edu.agh.iet.model.ExampleDTO;
import pl.edu.agh.iet.service.ExampleService;

@Controller
public class ExampleController {

    private final ExampleService exampleService;

    public ExampleController(ExampleService exampleService) {
        this.exampleService = exampleService;
    }

    @GetMapping("/example")
    public String exampleForm(Model model) {
        model.addAttribute("example", new ExampleDTO());
        return "example-form";
    }

    @PostMapping("/example")
    public String exampleSubmit(@ModelAttribute ExampleDTO exampleDTO) {
        exampleService.saveExample(exampleDTO);
        return "index";
    }
}
