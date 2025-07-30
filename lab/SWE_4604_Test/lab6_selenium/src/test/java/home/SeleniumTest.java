package home;

import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class SeleniumTest {
    WebDriver driver;

    @BeforeAll
    void setUpClass() {
        driver = new FirefoxDriver();
        driver.manage().window().maximize();
    }

    @Test
    void testLoggingIn() throws InterruptedException {
        driver.get("https://practicesoftwaretesting.com/auth/login");

        Thread.sleep(2000);
        driver.findElement(By.id("email"))
                .sendKeys("customer@practicesoftwaretesting.com");
        driver.findElement(By.id("password"))
                .sendKeys("welcome01");
        driver.findElement(By.xpath("//input[@type='submit' or @value='Login']"))
                .click();
        Thread.sleep(2000);

        String expectedUrl = "https://practicesoftwaretesting.com/account";
        String actualUrl = driver.getCurrentUrl();

        Assertions.assertEquals(expectedUrl, actualUrl,
                "The user should be redirected to the account page after logging in.");
    }

    @Test
    void testFavoritesPage() throws InterruptedException {
        driver.get("https://practicesoftwaretesting.com/auth/login");

        Thread.sleep(2000);
        driver.findElement(By.id("email"))
                .sendKeys("customer@practicesoftwaretesting.com");
        driver.findElement(By.id("password"))
                .sendKeys("welcome01");
        driver.findElement(By.xpath("//input[@type='submit' or @value='Login']"))
                .click();
        Thread.sleep(2000);

        driver.findElement(By.cssSelector("a.btn:nth-child(1)")).click();
        Thread.sleep(2000);

        String expectedUrl = "https://practicesoftwaretesting.com/account/favorites";
        String actualUrl = driver.getCurrentUrl();

        Assertions.assertEquals(expectedUrl, actualUrl,
                "The user should be redirected to the favorites page after clicking the favorites link.");

        String expectedTitle = "Favorites - Practice Software Testing - Toolshop - v5.0";
        String actualTitle = driver.getTitle();

        Assertions.assertEquals(expectedTitle, actualTitle,
                "The title of the favorites page should match the expected title.");
    }

    @Test
    void testProfilePage() throws InterruptedException {
        driver.get("https://practicesoftwaretesting.com/auth/login");

        Thread.sleep(2000);
        driver.findElement(By.id("email"))
                .sendKeys("customer@practicesoftwaretesting.com");
        driver.findElement(By.id("password"))
                .sendKeys("welcome01");
        driver.findElement(By.xpath("//input[@type='submit' or @value='Login']"))
                .click();
        Thread.sleep(2000);

        driver.findElement(By.cssSelector("a.btn:nth-child(2)")).click();
        Thread.sleep(2000);

        String expectedUrl = "https://practicesoftwaretesting.com/account/profile";
        String actualUrl = driver.getCurrentUrl();

        Assertions.assertEquals(expectedUrl, actualUrl,
                "The user should be redirected to the profile page after clicking the profile link.");

        String expectedTitle = "Profile - Practice Software Testing - Toolshop - v5.0";
        String actualTitle = driver.getTitle();

        Assertions.assertEquals(expectedTitle, actualTitle,
                "The title of the profile page should match the expected title.");
    }

    @Test
    void testContactUs() throws InterruptedException {
        driver.get("https://practicesoftwaretesting.com/contact");

        Thread.sleep(2000);
        driver.findElement(By.id("first_name"))
                .sendKeys("Jane");
        driver.findElement(By.id("last_name"))
                .sendKeys("Doe");
        driver.findElement(By.id("email"))
                .sendKeys("customer@practicesoftwaretesting.com");

        WebElement dropdown = driver.findElement(By.id("subject"));
        Select select = new Select(dropdown);
        select.selectByVisibleText("Payments");

        driver.findElement(By.id("message"))
                .sendKeys("This is a test contact message. This needs to be at least 50 characters long. "
                        + "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        + "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.");
        WebElement upload = driver.findElement(By.id("attachment"));
        upload.sendKeys("C:\\Users\\hasin\\Documents\\selenium-contact.txt");

        driver.findElement(By.xpath("//input[@type='submit' or @value='Send']"))
                .click();
        Thread.sleep(2000);

        String expectedRes = "Thanks for your message! We will contact you shortly.";
        String actualRes = driver.findElement(By.cssSelector(".alert"))
                .getText();

        Assertions.assertEquals(
                expectedRes,
                actualRes,
                "We should see a confirmation message after submitting the contact form.");
    }

    @AfterAll
    void tearDownClass() {
        if (driver != null) {
            driver.quit();
        }
    }
}
