package pl.edu.agh.iet.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ReservationDTO {

    private Integer id;
    private Integer clientId;
    private Integer tableId;
    private DateTimeFormat reservationDate;
    private String additionalInformation;
    private Boolean confirmed;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getClientId() {
        return clientId;
    }

    public void setClientId(Integer clientId) {
        this.clientId = clientId;
    }

    public Integer getTableId() {
        return tableId;
    }

    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }

    public DateTimeFormat getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(DateTimeFormat reservationDate) {
        this.reservationDate = reservationDate;
    }

    public String getAdditionalInformation() {
        return additionalInformation;
    }

    public void setAdditionalInformation(String additionalInformation) {
        this.additionalInformation = additionalInformation;
    }

    public Boolean getConfirmed() {
        return confirmed;
    }

    public void setConfirmed(Boolean confirmed) {
        this.confirmed = confirmed;
    }
}
