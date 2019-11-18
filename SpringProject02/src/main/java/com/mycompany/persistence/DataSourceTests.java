package com.mycompany.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mycompany.config.RootConfig;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class DataSourceTests {
	@Setter(onMethod_= { @Autowired })
	private DataSource dataSource;
	
	@Setter(onMethod_= { @Autowired })
	private SqlSessionFactory sqlSessionFactory;
	
	@Test
	public void testConnection() {
		try (Connection con = dataSource.getConnection()) {
			System.out.println("JDBC 연동 테스트");
			log.info(con);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testMyBatis() {
		try (SqlSession session = sqlSessionFactory.openSession();
				Connection con = session.getConnection();
				) {
					System.out.println("SqlSessionFactory 테스트");
					log.info(session);
					log.info(con);
				} catch (Exception e) {
					fail(e.getMessage());
				}
	}
		
}
