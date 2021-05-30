package pl.edu.agh.iet.service;

import java.util.List;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pl.edu.agh.iet.model.ProductDTO;
import pl.edu.agh.iet.model.ProductTypeDTO;

@Service
public class ProductService {

    private final JdbcTemplate jdbcTemplate;

    public ProductService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<ProductDTO> getAllProducts() {
        return jdbcTemplate.query("SELECT id, typeId, name FROM Product.Product", new BeanPropertyRowMapper<>(ProductDTO.class));
    }

    public List<ProductTypeDTO> getAllProductTypes() {
        return jdbcTemplate.query("SELECT id, type FROM Product.ProductType", new BeanPropertyRowMapper<>(ProductTypeDTO.class));
    }

    public void saveProduct(ProductDTO productDTO) {
        jdbcTemplate.update("INSERT INTO Product.Product (typeId, name) VALUES (?, ?)",
                productDTO.getTypeId(),
                productDTO.getName());
    }

    public void deleteProduct(ProductDTO productDTO) {
        jdbcTemplate.update("DELETE FROM Product.Product WHERE id = ?",
                productDTO.getId());
    }
}
