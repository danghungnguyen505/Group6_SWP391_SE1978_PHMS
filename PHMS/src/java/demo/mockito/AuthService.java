package demo.mockito;

public class AuthService {

    private final UserRepository userRepository;
    private final EmailService emailService;

    public AuthService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }

    public boolean login(String email, String password) {
        System.out.println("--- Dang kiem tra dang nhap cho: " + email + " ---");
        String dbPassword = userRepository.findPasswordByEmail(email);
        System.out.println("Mat khau lay tu Mock (Backend fake): " + dbPassword);

        if (password.equals(dbPassword)) {
            System.out.println("=> Pass correct! Dang goi EmailService de gui canh bao...");
            //emailService.sendLoginAlert(email);
            return true;
        }
        System.out.println("=> Sai pass! Khong gui mail.");
        return false;
    }
}
