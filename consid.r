#!/usr/bin/Rscript --vanilla
library(ggplot2)
library(scales)

salary <- data.frame(
  # http://www.quora.com/Management-Consulting-and-Management-Consulting-Firms/How-much-does-a-management-consulting-firm-charge-for-one-case
  billed.weekly.rate = rep(seq(15000, 25000, 5000), each = 5 * 3),

  # http://ask.metafilter.com/74600/Help-me-understand-billable-hour-expectations-for-people-other-than-lawyers
  utilization = rep(rep(seq(0.5,0.9,0.1), 3), each = 3),

  # http://blog.asmartbear.com/consulting-company-accounting.html
  # http://www.wahby.com/articles/overhead_defined.htm
  overhead    = seq(1.1,1.7,0.3)
)

weeks.per.year <- 50

salary$value.created <- salary$billed.weekly.rate * salary$utilization * weeks.per.year

# Fresh out of MBA seems to be around $200,000
# http://www.caseinterview.com/consulting-salary
# http://www.glassdoor.com/Salaries/management-consultant-salary-SRCH_KO0,21.htm
# http://managementconsulted.com/summer-internship/the-truth-behind-consulting-salaries-from-analyst-thru-partner/
salary$salary <- round(salary$value.created / (1 + salary$overhead), -1)
salary$billed.weekly.rate <- paste('$', salary$billed.weekly.rate, sep = '')
salary$overhead <- factor(paste(100 * salary$overhead, '%', sep = ''))

p <- ggplot(salary) +
  aes(x = utilization, group = paste(billed.weekly.rate, overhead),
      color = billed.weekly.rate, y = salary, linetype = overhead) +
  geom_line() + scale_y_continuous('Salary', labels = dollar) +
  labs(title = 'What is a reasonable salary for Thomas Levine?') +
  scale_x_continuous("Proportion of Thomas's working time that is billable")
