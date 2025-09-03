import hvac
from netmiko import ConnectHandler

# gets vault token from evironment variable stored in .bashrc
#will fix this is very bad practice
vaultToken = ''

# uses token to connect to vault
client = hvac.Client(
    url='https://10.10.20.40:8200',
    token=vaultToken,
    verify=False
)

# set vault path for switch credentials
vaultPath = 'network/3560v2'

# sets secret mount path
secret = client.secrets.kv.v2.read_secret_version(path=vaultPath, mount_point='secret')

# gets switch username
switchUsername = secret['data']['data']['username']

# gets switch password
switchPassword = secret['data']['data']['password']

switch = {
    'device_type': 'cisco_ios_telnet',
    'host': '192.168.137.2',
    'username': switchUsername,
    'password': switchPassword,
 }

connect = ConnectHandler(**switch)
connect.enable()

tftpServerIp = "10.10.10.10"
downloadlocation = "3560v2/config/"
downloadFileName = "3560v2.cfg"
downloadInit = "copy tftp: running-config"
saveInit = "copy running-config startup-config"

# backup init
print("               Config Download              ")
print("--------------------------------------------")
connect.send_command_timing(downloadInit)

# tftp server ip input
print("Connecting to TFTP Server...")
connect.send_command_timing(tftpServerIp)

# backup file name
print("Searching for Download Location...")
connect.send_command_timing(downloadlocation + downloadFileName)

# save it to the running config
print("Saving to Running Config...")
connect.send_command_timing("\n")

# save running config to startup config
print("Saving Running Config to Startup Config...")
connect.send_command_timing(saveInit)
connect.disconnect()

print("Download Successfull!")
