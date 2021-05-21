package pl.edu.agh.iet.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

public class ExampleDTO {

    private Long numberExample;
    private String textExample;
    private String textAreaExample;
    private SelectExample selectExample;
    private RadioExample radioExample;
    private Boolean checkboxExample;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime dateTimeExample;

    public Long getNumberExample() {
        return numberExample;
    }

    public void setNumberExample(Long numberExample) {
        this.numberExample = numberExample;
    }

    public String getTextExample() {
        return textExample;
    }

    public void setTextExample(String textExample) {
        this.textExample = textExample;
    }

    public String getTextAreaExample() {
        return textAreaExample;
    }

    public void setTextAreaExample(String textAreaExample) {
        this.textAreaExample = textAreaExample;
    }

    public SelectExample getSelectExample() {
        return selectExample;
    }

    public void setSelectExample(SelectExample selectExample) {
        this.selectExample = selectExample;
    }

    public RadioExample getRadioExample() {
        return radioExample;
    }

    public void setRadioExample(RadioExample radioExample) {
        this.radioExample = radioExample;
    }

    public Boolean getCheckboxExample() {
        return checkboxExample;
    }

    public void setCheckboxExample(Boolean checkboxExample) {
        this.checkboxExample = checkboxExample;
    }

    public LocalDateTime getDateTimeExample() {
        return dateTimeExample;
    }

    public void setDateTimeExample(LocalDateTime dateTimeExample) {
        this.dateTimeExample = dateTimeExample;
    }
}
