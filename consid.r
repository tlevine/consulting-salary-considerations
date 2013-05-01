#!/usr/bin/Rscript --vanilla
library(ggplot2)
library(scales)

salary <- data.frame(
  # http://www.quora.com/Management-Consulting-and-Management-Consulting-Firms/How-much-does-a-management-consulting-firm-charge-for-one-case
  # http://www.amstat.org/sections/cnsl/newsletter/pdf_archive/vol23no1.pdf
  billed.hourly.rate = rep(seq(200, 400, 100), each = 5 * 3),

  # http://ask.metafilter.com/74600/Help-me-understand-billable-hour-expectations-for-people-other-than-lawyers
  utilization = rep(rep(seq(0.1,0.9,0.2), 3), each = 3),

  # http://blog.asmartbear.com/consulting-company-accounting.html
  # http://www.wahby.com/articles/overhead_defined.htm
  overhead    = seq(1.1,1.7,0.3)
)

hours.per.year <- 50 * 5 * 8

salary$value.created <- salary$billed.hourly.rate * salary$utilization * hours.per.year

# http://www.caseinterview.com/consulting-salary
# http://www.glassdoor.com/Salaries/management-consultant-salary-SRCH_KO0,21.htm
# http://managementconsulted.com/summer-internship/the-truth-behind-consulting-salaries-from-analyst-thru-partner/
salary$salary <- round(salary$value.created / (1 + salary$overhead), -1)
salary$billed.hourly.rate <- paste('$', salary$billed.hourly.rate, sep = '')
salary$overhead <- factor(paste(100 * salary$overhead, '%', sep = ''))

p <- ggplot(salary) +
  aes(x = utilization, group = paste(billed.hourly.rate, overhead),
      color = billed.hourly.rate, y = salary, linetype = overhead) +
  geom_line() + scale_y_continuous('Salary', labels = dollar) +
  labs(title = 'What is a reasonable salary for Thomas Levine?') +
  scale_x_continuous("Proportion of Thomas's working time that is billable")
