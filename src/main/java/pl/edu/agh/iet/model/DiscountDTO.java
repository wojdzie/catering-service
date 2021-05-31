package pl.edu.agh.iet.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import org.springframework.format.annotation.DateTimeFormat;

public class DiscountDTO {

    private Integer id;
    private Integer minOrderNumber;
    private BigDecimal minOrderPrice;
    private Boolean available;
    private Integer discount;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime validityDate;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMinOrderNumber() {
        return minOrderNumber;
    }

    public void setMinOrderNumber(Integer minOrderNumber) {
        this.minOrderNumber = minOrderNumber;
    }

    public BigDecimal getMinOrderPrice() {
        return minOrderPrice;
    }

    public void setMinOrderPrice(BigDecimal minOrderPrice) {
        this.minOrderPrice = minOrderPrice;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(Integer discount) {
        this.discount = discount;
    }

    public LocalDateTime getValidityDate() {
        return validityDate;
    }

    public void setValidityDate(LocalDateTime validityDate) {
        this.validityDate = validityDate;
    }
}
