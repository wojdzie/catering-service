package pl.edu.agh.iet.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pl.edu.agh.iet.model.MenuDTO;
import pl.edu.agh.iet.model.MenuSizeDTO;

@Service
public class MenuService {

    private final JdbcTemplate jdbcTemplate;

    public MenuService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<MenuDTO> getCurrentMenu() {
        return jdbcTemplate.query("SELECT pm.id, pm.productId, pt.type AS productType, pp.name AS productName, pp.price, pm.endDate FROM Purchase.Menu pm INNER JOIN Product.Product pp ON pm.productId = pp.id INNER JOIN Product.ProductType pt ON pp.typeId = pt.id WHERE pm.endDate IS NULL", new BeanPropertyRowMapper<>(MenuDTO.class));
    }

    public void generateNewMenu(MenuSizeDTO menuSizeDTO) {
        jdbcTemplate.update("Purchase.GenerateNewMenu ?", menuSizeDTO.getSize());
    }
}
