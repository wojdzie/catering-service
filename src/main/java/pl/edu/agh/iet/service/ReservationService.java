package pl.edu.agh.iet.service;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pl.edu.agh.iet.model.DiscountDTO;
import pl.edu.agh.iet.model.ExampleDTO;
import pl.edu.agh.iet.model.ReservationDTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ReservationService {

    private final JdbcTemplate jdbcTemplate;

    public ReservationService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<ReservationDTO> getAllReservations() {
        return jdbcTemplate.query("SELECT id,clientId, tableId, reservationDate, additionalInformation FROM Restaurant.Reservation", new BeanPropertyRowMapper<>(ReservationDTO.class));
    }

    public void saveReservation(ReservationDTO reservationDTO) {
        jdbcTemplate.update("INSERT INTO Restaurant.Reservation (clientId, tableId, reservationDate, additionalInformation) VALUES (?, ?, ?, ?)",
                reservationDTO.getClientId(),
                reservationDTO.getTableId(),
                reservationDTO.getReservationDate(),
                reservationDTO.getAdditionalInformation());
    }

    public void deleteReservation(ReservationDTO reservationDTO) {
        jdbcTemplate.update("DELETE FROM Restaurant.Reservation WHERE id = ?",
                reservationDTO.getId());
    }
}
