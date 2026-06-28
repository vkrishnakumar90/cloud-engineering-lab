# Linux Fundamentals for Cloud Platform Engineers

> Part of **Project Phoenix – Cloud Engineering Lab**
>
> This repository documents my journey from Release Engineering to Cloud Platform Engineering through hands-on learning, public-safe notes, and production-oriented examples.

---

# Overview

Linux is the foundation of modern cloud infrastructure. Most cloud servers, Kubernetes worker nodes, containers, and platform services run on Linux.

Learning Linux is not about memorizing commands—it's about understanding how systems work and how to troubleshoot them methodically.

---

# 🌱 Simple Explanation

Think of Linux as a house.

```
/
├── home
├── etc
├── var
├── usr
├── tmp
```

Every room has a purpose.

If you know where things are kept, you can quickly find what you need.

---

# 🚀 Engineering Perspective

As a Cloud Platform Engineer or SRE, Linux is the operating system you'll interact with daily.

Typical activities include:

* Reading application logs
* Verifying configurations
* Investigating production issues
* Managing services
* Inspecting running processes
* Debugging network connectivity

Understanding the Linux filesystem significantly reduces troubleshooting time.

---

# Important Directories

| Directory  | Purpose                          | Memory Trick           |
| ---------- | -------------------------------- | ---------------------- |
| `/`        | Root directory                   | Everything starts here |
| `/home`    | User home directories            | User files             |
| `/etc`     | Configuration files              | Recipe Book            |
| `/var/log` | Log files                        | Diary                  |
| `/tmp`     | Temporary files                  | Temporary workspace    |
| `/usr/bin` | Executable programs and commands | Tool Box               |

---

# Essential Commands

## pwd

Displays the current working directory.

```bash
pwd
```

Remember:

> **Where am I?**

---

## ls

Lists files and folders in the current directory.

```bash
ls
```

Remember:

> **What is here?**

---

## cd

Changes the current directory.

```bash
cd /etc
```

Remember:

> **Go there.**

---

## cat

Displays the complete contents of a file.

```bash
cat application.conf
```

Best for smaller files.

---

## less

Reads large files one page at a time.

```bash
less application.log
```

Exit using:

```
q
```

---

## grep

Searches for specific text inside files.

```bash
grep -i error application.log
```

Useful when working with large log files.

---

# Absolute vs Relative Paths

## Absolute Path

Starts with `/`

Example:

```bash
cd /etc/nginx
```

Works regardless of the current directory.

---

## Relative Path

Starts from the current directory.

Example:

```bash
cd Documents
```

Depends on where you currently are.

---

# Production Scenario

## Scenario

Users report that the application is returning HTTP 503 errors.

A structured investigation might look like this:

```
Read Logs
        ↓
Understand the Error
        ↓
Verify Configuration
        ↓
Check Dependencies
        ↓
Apply the Correct Fix
        ↓
Validate
```

Avoid restarting services before understanding the root cause.

---

# Interview Notes

### Q: Why check `/var/log` before `/etc`?

Because logs provide evidence of what happened.

Configuration files explain how the application is expected to behave.

Logs help identify the problem before investigating configuration.

---

### Q: Why use `grep` instead of opening the entire log?

Large production logs may contain thousands of lines.

`grep` allows engineers to quickly search for relevant messages such as:

* error
* exception
* timeout
* refused

This speeds up troubleshooting significantly.

---

### Q: Why does `cd /etc` work from any location?

Because it is an **absolute path**.

Paths beginning with `/` always start from the Linux root directory.

---

# 💡 Memory Tricks

### `/etc`

📖 Recipe Book

Changing the recipe changes how the application behaves.

---

### `/var/log`

📔 Diary

Logs record what happened.

Changing the diary does **not** change how the application behaves.

---

### Linux Navigation

* `pwd` → Where am I?
* `ls` → What is here?
* `cd` → Go there.
* `grep` → Find text.
* `less` → Read comfortably.

---

# Engineering Mindset

Technology changes.

Commands change.

Tools change.

Engineering thinking remains the same.

```
Evidence
      ↓
Hypothesis
      ↓
Action
```

This mindset applies equally to Linux, Docker, Kubernetes, AWS, and modern cloud platforms.

---

## Learning Status

* ✅ Linux Filesystem
* ✅ Essential Navigation Commands
* ✅ Reading Logs
* ✅ Basic Troubleshooting Mindset
* ✅ Production Investigation Workflow
