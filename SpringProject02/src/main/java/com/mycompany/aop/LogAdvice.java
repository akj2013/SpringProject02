package com.mycompany.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect // 해당 클래스의 객체가 Aspect를 구현한 것임을 나타낸다.
@Log4j
@Component // 스프링에서 빈으로 인식하기 위해서 사용한다.
public class LogAdvice {
	
	// BeforeAdvice를 구현한 메서드를 추가한다.
	@Before("execution(* com.mycompany.service.SampleService*.*(..))") 
	public void logBefore() {
		log.info("===================");
	}
	
	@Before("execution(* com.mycompany.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		log.info("str1 : " + str1);
		log.info("str2 : " + str2);
	}
	
	// @AfterThrowing
	// 코드를 실행하다 보면 파라미터의 값이 잘못되어서 예외가 발생하는 경우가 많습니다.
	// AOP의 @AfterThrowing 어노테이션은 지정된 대상이 예외를 발생한 후에 동작하면서 문제를 찾을 수 있도록 도와줍니다.
	@AfterThrowing(pointcut = "execution(* com.mycompany.service.SampleService*.*(..))", throwing = "exception")
	public void logException(Exception exception) {
		log.info("EXCEPTION !!! ");
		log.info(exception);
	}
	
	// @Around
	// 직접 대상 메서드를 실행할 수 있는 권한을 가지고 있고, 메서드의 실행 전과 실행 후에 처리가 가능합니다.
	@Around("execution(* com.mycompany.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("Target : " + pjp.getTarget());
		log.info("Param : " + Arrays.toString(pjp.getArgs()));
		
		// invoke method
		Object result = null;
		
		try {
			result = pjp.proceed();
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("TIME : " + (end - start));
		
		return result;
	}
}
