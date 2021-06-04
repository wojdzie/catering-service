package pl.edu.agh.iet.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import pl.edu.agh.iet.model.*;
import pl.edu.agh.iet.service.ExampleService;
import pl.edu.agh.iet.service.ReservationService;

import java.util.List;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    private final ReservationService reservationService;

    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    @GetMapping
    public String reservationList(Model model) {
        List<ReservationDTO> reservation = reservationService.getAllReservations();
        model.addAttribute("reservation", reservation);
        return "reservation-list";
    }

    @GetMapping("/add")
    public String addReservationForm(Model model) {
        model.addAttribute("reservation", new ReservationDTO());
        return "reservation-add-form";
    }

    @PostMapping("/add")
    public String addReservationSubmit(Model model, @ModelAttribute ReservationDTO reservationDTO) {
        reservationService.saveReservation(reservationDTO);
        return reservationList(model);
    }

    @GetMapping("/remove")
    public String removeReservationForm(Model model) {
        List<ReservationDTO> reservation = reservationService.getAllReservations();
        model.addAttribute("reservation", reservation);
        model.addAttribute("reservation", new ReservationDTO());
        return "reservation-remove-form";
    }

    @PostMapping("/remove")
    public String removeReservationSubmit(Model model, @ModelAttribute ReservationDTO reservationDTO) {
        reservationService.deleteReservation(reservationDTO);
        return reservationList(model);
    }
}
