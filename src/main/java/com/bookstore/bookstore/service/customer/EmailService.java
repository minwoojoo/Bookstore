package com.bookstore.bookstore.service.customer;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

/**
 * 이메일 발송 서비스
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;
    
    /**
     * 회원가입 이메일 인증번호 발송
     * 
     * @param toEmail 수신자 이메일
     * @param verificationCode 6자리 인증번호
     */
    public void sendEmailVerification(String toEmail, String verificationCode) {
        SimpleMailMessage message = new SimpleMailMessage();

        try {
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("[Online Bookstore] 이메일 인증번호 안내");
            String text = String.format(
                    "안녕하세요!\n\n" +
                            "Online Bookstore 이메일 인증번호는 다음과 같습니다:\n\n" +
                            "인증번호: %s\n\n" +
                            "이 인증번호는 5분간 유효합니다. 회원가입 페이지나 마이페이지에서 인증번호를 입력해주세요.\n\n" +
                            "감사합니다.\n" +
                            "Online Bookstore 팀 드림",
                    verificationCode
            );
            message.setText(text);

            mailSender.send(message);
            log.info("이메일 인증번호 발송 성공: to={}, subject={}", toEmail, message.getSubject());
            
        } catch (MailException e) {
            log.error("이메일 인증번호 발송 실패: to={}, subject={}, error={}", toEmail, message.getSubject(), e.getMessage(), e);
            throw new RuntimeException("이메일 발송에 실패했습니다. 이메일 주소를 확인해주세요.");
        }
    }

    /**
     * 비밀번호 재설정 인증번호 발송
     * 
     * @param toEmail 수신자 이메일
     * @param userId 사용자 아이디
     * @param verificationCode 6자리 인증번호
     */
    public void sendPasswordResetEmail(String toEmail, String userId, String verificationCode) {
        SimpleMailMessage message = new SimpleMailMessage();

        try {
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("[Online Bookstore] 비밀번호 재설정 인증번호 안내");
            String text = String.format(
                    "안녕하세요, %s님.\n\n" +
                            "비밀번호 재설정을 위한 인증번호는 다음과 같습니다:\n\n" +
                            "인증번호: %s\n\n" +
                            "이 인증번호는 5분간 유효합니다. 인증번호를 입력하여 비밀번호를 재설정해주세요.\n\n" +
                            "감사합니다.\n" +
                            "Online Bookstore 팀 드림",
                    userId, verificationCode
            );
            message.setText(text);

            mailSender.send(message);
            log.info("비밀번호 재설정 이메일 발송 성공: to={}, subject={}", toEmail, message.getSubject());
            
        } catch (MailException e) {
            log.error("비밀번호 재설정 이메일 발송 실패: to={}, subject={}, error={}", toEmail, message.getSubject(), e.getMessage(), e);
            throw new RuntimeException("이메일 발송에 실패했습니다. 이메일 주소를 확인해주세요.");
        }
    }

}

