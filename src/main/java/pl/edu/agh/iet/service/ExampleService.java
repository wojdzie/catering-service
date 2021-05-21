package pl.edu.agh.iet.service;

import java.time.format.DateTimeFormatter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pl.edu.agh.iet.model.ExampleDTO;

@Service
public class ExampleService {

    private final JdbcTemplate jdbcTemplate;

    public ExampleService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void saveExample(ExampleDTO exampleDTO) {
        jdbcTemplate.update("INSERT INTO Example.Example (numberExample, textExample, textAreaExample, selectExample, dateExample, radioExample, checkboxExample) VALUES (?, ?, ?, ?, ?, ?, ?)",
                exampleDTO.getNumberExample(),
                exampleDTO.getTextExample(),
                exampleDTO.getTextAreaExample(),
                exampleDTO.getSelectExample().toString(),
                exampleDTO.getDateTimeExample().format(DateTimeFormatter.ISO_DATE),
                exampleDTO.getRadioExample().toString(),
                exampleDTO.getCheckboxExample());
    }
}
