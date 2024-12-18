import javax.swing.*;
import java.awt.*;
import CLIPSJNI.*;

public class CellPhone {
    private Environment clips;
    private JFrame frame;
    private JLabel textLabel;
    private JPanel choicesPanel;
    private JButton prevButton;
    private JButton nextButton;
    private ButtonGroup choicesGroup;

    public CellPhone() {
        clips = new Environment();

        try {
            clips.load("resources/base.clp");
            clips.reset();
        } catch (Exception e) {
            showError("Błąd podczas wczytywania pliku CLP: " + e.getMessage());
            return;
        }

        frame = new JFrame("CellPhoneGUI");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(1000, 800);
        frame.setLayout(null);

        textLabel = new JLabel("", SwingConstants.CENTER);
        textLabel.setFont(new Font("Arial", Font.BOLD, 22));
        textLabel.setBounds(50, 10, 900, 400);
        frame.add(textLabel);

        choicesPanel = new JPanel();
        choicesPanel.setBounds(300, 500, 350, 50);
        frame.add(choicesPanel);

        prevButton = new JButton("Go Back");
        prevButton.setPreferredSize(new Dimension(150, 50));
        prevButton.setEnabled(false);
        prevButton.setBounds(300, 650, 150, 70);
        prevButton.addActionListener(e -> handlePrev());
        frame.add(prevButton);

        nextButton = new JButton("Next Question");
        nextButton.setPreferredSize(new Dimension(150, 50));
        nextButton.setBounds(500, 650, 150, 70);
        nextButton.addActionListener(e -> handleNext());
        frame.add(nextButton);

        updateGUIState();
        frame.setVisible(true);
    }

    private void updateGUIState() {
        try {
            clips.run();

            PrimitiveValue stateListQuery = clips.eval("(find-all-facts ((?f state-list)) TRUE)");
            if (stateListQuery.size() == 0) {
                showError("Lista nie zawiera zadnego faktu");
                return;
            }

            FactAddressValue stateListFact = (FactAddressValue) stateListQuery.get(0);
            String currentId = stateListFact.getFactSlot("now").toString();

            PrimitiveValue uiStateQuery = clips.eval("(find-all-facts ((?f GUI-state)) (eq ?f:id " + currentId + "))");
            if (uiStateQuery.size() == 0) {
                showError("Blad odczytu z GUI-state");
                return;
            }

            FactAddressValue uiState = (FactAddressValue) uiStateQuery.get(0);
            String displayText = uiState.getFactSlot("text").toString().replace("\"", "").replace("\n", "<br>");
            textLabel.setText("<html><center>" + displayText + "</center></html>");

            PrimitiveValue validAnswers = uiState.getFactSlot("answers");
            String currentAnswer = uiState.getFactSlot("answer").toString();

            choicesPanel.removeAll();
            choicesGroup = new ButtonGroup();

            for (int i = 0; i < validAnswers.size(); i++) {
                String answer = validAnswers.get(i).toString();
                JRadioButton rb = new JRadioButton(answer);
                rb.setFont(new Font("Arial", Font.PLAIN, 24));
                rb.setActionCommand(answer);
                if (answer.equals(currentAnswer)) {
                    rb.setSelected(true);
                }
                rb.setBounds(i*50, 0, 400, 50);
                choicesGroup.add(rb);
                choicesPanel.add(rb);
            }

            choicesPanel.revalidate();
            choicesPanel.repaint();

            String state = uiState.getFactSlot("state").toString();
            if (state.equals("final")) {
                nextButton.setText("Restart");
                nextButton.setEnabled(true);
                prevButton.setEnabled(true);
            } else {
                nextButton.setText("Next Question");
                nextButton.setEnabled(true);
                prevButton.setEnabled(true);
            }
        } catch (Exception e) {
            showError("Błąd podczas aktualizacji GUI: " + e.getMessage());
        }
    }

    private void handleNext() {
        try {
            String selectedAnswer = null;
            if (choicesGroup.getSelection() != null) {
                selectedAnswer = choicesGroup.getSelection().getActionCommand();
            }

            PrimitiveValue stateListQuery = clips.eval("(find-all-facts ((?f state-list)) TRUE)");
            if (stateListQuery.size() == 0) {
                showError("Lista nie zawiera faktow");
                return;
            }

            FactAddressValue stateListFact = (FactAddressValue) stateListQuery.get(0);
            String currentId = stateListFact.getFactSlot("now").toString();

            if (nextButton.getText().equals("Restart")) {
                clips.reset();
            } else {
                if (selectedAnswer != null) {
                    clips.assertString("(transition " + currentId + " " + selectedAnswer + ")");
                } else {
                    clips.assertString("(transition " + currentId + ")");
                }
            }

            updateGUIState();
        } catch (Exception e) {
            showError("Błąd podczas obsługi Next: " + e.getMessage());
        }
    }

    private void handlePrev() {
        try {
            PrimitiveValue stateListQuery = clips.eval("(find-all-facts ((?f state-list)) TRUE)");
            if (stateListQuery.size() == 0) {
                showError("Lista nie zawiera faktow");
                return;
            }

            FactAddressValue stateListFact = (FactAddressValue) stateListQuery.get(0);
            String currentId = stateListFact.getFactSlot("now").toString();
            clips.assertString("(prev " + currentId + ")");

            updateGUIState();
        } catch (Exception e) {
            showError("Błąd podczas obsługi Prev: " + e.getMessage());
        }
    }

    private void showError(String message) {
        JOptionPane.showMessageDialog(frame, message, "Błąd", JOptionPane.ERROR_MESSAGE);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(CellPhone::new);
    }
}
