# learners
![](https://github.com/Onnesok/Learners/blob/main/assets/mockup.png)

learners is a LLM app for our 370 database management system project.

Learners is a LMS or learning management system app designed for students to make their online learning easy with its minimalistic design and easy to use features.


![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Browser](https://img.shields.io/badge/Web-FF7139?style=for-the-badge&logo=Browser&logoColor=white)


## Features
- Internet Connectivity check on startup and through whole life cycle
- course and app data fetch from mysql database
- Generative Ai / Gemini integration
- Profile screen with user data data fetch and all the other things
- Course enrollment for user
- Dashboard for users enrolled course and wishlist
- Instructor application for users
- PDF viewer



## Database creation

Create user database......here user database table is named sign_up
```sql
CREATE TABLE sign_up (
    user_id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary key with auto-increment
    uemail VARCHAR(40) NOT NULL UNIQUE,      -- Email column with unique constraint
    ufname VARCHAR(40) NOT NULL,             -- User's first name
    ulname VARCHAR(40) NOT NULL,             -- User's last name
    upassword VARCHAR(40) NOT NULL           -- User's password
);
```

Now create categories database

```sql
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each category
    title VARCHAR(255) NOT NULL,
    image VARCHAR(255) NOT NULL,                -- Category Image
    description TEXT                            -- Description of the category
);

```
sample inserts
```sql

INSERT INTO categories (title, image, description) VALUES
('Programming', '/assets/images/programming.png', 'Courses related to competitive programming, app development, web dev and more'),
('UI/UX', '/assets/images/designer.png', 'Courses on UI/UX design'),
('Digital Marketing', '/assets/images/marketing.png', 'Courses for digital marketing'),
('Robotics', '/assets/images/robotics.png', 'Courses for Robotics'),
('Data entry', '/assets/images/management.png', 'Courses for dataentry');
```

Create courses database

```sql
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique identifier for each course
    title VARCHAR(255) NOT NULL, 
    instructor_name VARCHAR(255) NOT NULL,
    duration VARCHAR(255) NOT NULL, 
    price DECIMAL(10, 2) DEFAULT 0.00,         
    release_date DATE, 
    video_content TEXT,                          -- Multiple video links, comma-separated
    description TEXT,                            -- Course description
    video_title VARCHAR(255),                    -- Title for the video content
    prerequisite TEXT, 
    rating_count INT DEFAULT 0,                  -- Number of ratings received
    certificate BOOLEAN DEFAULT FALSE,           -- Indicates if a certificate is provided
    intro_video VARCHAR(255),                    -- URL of the introductory video
    image VARCHAR(255),                          -- Course banner
    stars DECIMAL(2, 1) NOT NULL,                -- Average rating in stars
    discount VARCHAR(255),                       -- Discount applied to the course
    category_id INT,                             -- Foreign key referencing the category
    FOREIGN KEY (category_id) REFERENCES categories(category_id)  -- Foreign key constraint
);

```

sample inserts
```sql
INSERT INTO courses 
(title, instructor_name, duration, price, release_date, video_content, description, video_title, prerequisite, rating_count, certificate, intro_video, image, stars, discount, category_id) VALUES
('Introduction to Flutter', 'John Doe', '10 hours', 0.00, '2024-08-01', 'video1_id,video2_id', 'Learn Flutter from scratch with hands-on examples.', 'Introduction to Flutter,Flutter Setup', 'Basic programming knowledge', 0, FALSE, 'intro_video_id1', '/assets/images/iron_man.jpg', 5.0, '10%', 1),
('Advanced App Development', 'Jane Smith', '12 hours', 0.00, '2024-09-01', 'video3_id,video4_id', 'Take your app development skills to the next level.', 'App Development Introduction,App Optimization', 'Completion of Introduction to Flutter', 0, FALSE, 'intro_video_id2', '/assets/images/iron_man.jpg', 4.8, '15%', 1),
('UX Principles', 'Emily Davis', '8 hours', 0.00, '2024-07-15', 'video5_id,video6_id', 'Understand the key principles of user experience design.', 'UX Introduction,User Research', 'None', 0, FALSE, 'intro_video_id3', '/assets/images/apex.jpg', 4.5, 'No', 2),
('Digital Marketing Basics', 'Alex Johnson', '6 hours', 0.00, '2024-05-20', 'video7_id,video8_id', 'Learn the fundamentals of digital marketing strategies.', 'Digital Marketing Introduction,Social Media Strategy', 'Basic understanding of social media', 0, FALSE, 'intro_video_id4', '/assets/images/league1.jpg', 4.7, '10%', 3),
('Intro to Data Entry', 'Tony Stark', '3 hours', 0.00, '2024-08-01', 'video9_id,video10_id', 'Learn the basics of data entry operations.', 'Data Entry Introduction,Data Entry Practices', 'Basic Computer knowledge', 0, FALSE, 'intro_video_id5', '/assets/images/dataentry.jpg', 5.0, '10%', 5),
('Introduction to Robotics', 'Ratul Hasan', '60 hours', 0.00, '2024-08-01', 'video11_id,video12_id', 'An introduction to robotics and its applications.', 'Robotics Introduction,Robotics Assembly', 'Basic programming knowledge', 0, FALSE, 'intro_video_id6', '/assets/images/robotics1.jpg', 5.0, '10%', 4);

```
Create enrollment table
```sql
CREATE TABLE enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    uemail VARCHAR(40) NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (uemail) REFERENCES sign_up(uemail),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE KEY (uemail, course_id)  -- Ensures a user cannot enroll in the same course more than once
);
```
Sample inserts

```sql
INSERT INTO enrollment (uemail, course_id) VALUES
('stark@gmail.com', 1),
('stark@gmail.com', 3),
('dave@gmail.com', 5);
```

Now create App rating database
```sql
CREATE TABLE app_rating_db (
    app_rating_db_id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary key with auto-increment
    uemail VARCHAR(40) NOT NULL,                      -- Email associated with the rating
    app_rating INT NOT NULL,                          -- App rating (e.g., 1-5 stars)
    FOREIGN KEY (uemail) REFERENCES sign_up(uemail),  -- Foreign key referencing uemail in sign_up
    UNIQUE KEY (uemail)                               -- Ensures each user can only rate once
);
```

Ok now bug report database
```sql
CREATE TABLE bug_report (
    bug_report_id INT AUTO_INCREMENT PRIMARY KEY,   -- Primary key with auto-increment
    uemail VARCHAR(40) NOT NULL,                    -- Email of the user reporting the bug
    issue_description TEXT NOT NULL,                -- Description of the reported issue
    FOREIGN KEY (uemail) REFERENCES sign_up(uemail) -- Foreign key referencing uemail in sign_up
);
```

# Working
