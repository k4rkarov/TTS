# Tiny Toolkit Suite</h1>
<br>
<p>The Tiny Toolkit Suite (TTS) is a collection of scripts designed to automate exploration processes and enhance report's features.</p>

<br>

> [!NOTE]  
> Most tools have a -h, --help option which explains how the script works.

<br>

## Tools

### dmarc_checker.sh
This script verifies the presence of a DMARC policy and checks if the policy is set to 'p=none,' indicating a vulnerability to spoofing attacks.

```
Usage: ./dmarc_checker.sh -f <domains_file>
```

### rezise_mobile.sh
This script automatically resizes mobile screenshots to an 800x600 resolution, making it an ideal size for crafting reports.
Download the script to the folder where you want to resize the mobile images and execute it.

```
Usage: ./rezise_mobile.sh
```


### rezise_window.sh
This script automatically resizes your application's windows for taking screenshots to an 800x600 resolution, making it an ideal size for crafting reports.
Download the script and then configure a keyboard shortcut in your operating system (recommended shortcut: `Ctrl+Alt+R`).

<details>
  <summary>Click here to see a keyboard configuration example</summary>
  <p align=center><img src="https://raw.githubusercontent.com/k4rkarov/TTS/main/img/resize_window.png"></p>
</details>

```
Usage: Trigger the shortcut (e.g. Ctrl+Alt+R) to start the tool, then click on the window you want to resize.
```



### subtakeover.sh
This script will check if a subdomain is prone to subdomain takeover.

```
Usage: ./subtakeover.sh <filename>
```




### bashrc-with-steroids.sh
This script applies hardening settings to your Bash shell.

```
Usage: ./bashrc-with-steroids.sh
```




### usermail_generator.sh
This script generates emails for brute force testing.

```
Usage: ./usermail_generator.sh [-h|--help] [-d|--domain DOMAIN] [-n|--number NUMBER] [-l|--language LANGUAGE] [-f|--fullname]
```
