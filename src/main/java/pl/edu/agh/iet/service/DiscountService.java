package pl.edu.agh.iet.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.context.annotation.Bean;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pl.edu.agh.iet.model.DiscountDTO;
import pl.edu.agh.iet.model.ProductTypeDTO;

@Service
public class DiscountService {

    private final JdbcTemplate jdbcTemplate;

    public DiscountService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<DiscountDTO> getAllDiscounts() {
        return jdbcTemplate.query("SELECT id, minOrderNumber, minOrderPrice, available, discount, validityDate FROM StaticData.Discount", new BeanPropertyRowMapper<>(DiscountDTO.class));
    }

    public void saveDiscount(DiscountDTO discountDTO) {
        String validityDateValue = null;
        if (discountDTO.getValidityDate() != null) {
            LocalDateTime validityDate = discountDTO.getValidityDate();
            validityDateValue = validityDate.format(DateTimeFormatter.ISO_DATE);
        }
        jdbcTemplate.update("INSERT INTO StaticData.Discount (minOrderNumber, minOrderPrice, available, discount, validityDate) VALUES (?, ?, ?, ?, ?)",
                discountDTO.getMinOrderNumber(),
                discountDTO.getMinOrderPrice(),
                true,
                discountDTO.getDiscount(),
                validityDateValue);
    }

    public void deleteDiscount(DiscountDTO discountDTO) {
        jdbcTemplate.update("DELETE FROM StaticData.Discount WHERE id = ?",
                discountDTO.getId());
    }
}
