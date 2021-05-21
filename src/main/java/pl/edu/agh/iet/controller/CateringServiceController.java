package pl.edu.agh.iet.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CateringServiceController {

    @GetMapping("/")
    public String mainPage() {
        return "index";
    }

}