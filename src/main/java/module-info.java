module com.java.project.characterrecognition {
    requires javafx.controls;
    requires javafx.fxml;

    requires org.controlsfx.controls;
    requires com.dlsc.formsfx;
    requires org.kordamp.ikonli.javafx;
    requires org.kordamp.bootstrapfx.core;

    opens com.java.project.characterrecognition to javafx.fxml;
    exports com.java.project.characterrecognition;
}