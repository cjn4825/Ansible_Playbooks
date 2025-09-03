import hvac
from netmiko import ConnectHandler

# gets vault token from evironment variable stored in .bashrc
# nothing for now will change
vaultToken = ''

# uses token to connect to vault
client = hvac.Client(
    url='https://10.10.20.40:8200',
    token=vaultToken,
    verify=False
) # don't worry about dns for now

# set vault path for switch credentials
vaultPath = 'network/3560v2'

# sets secret mount path
secret = client.secrets.kv.v2.read_secret_version(path=vaultPath, mount_point='secret')

# gets 3560 switch local username
switchUsername = secret['data']['data']['username']

# gets 3560 local password
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
backuplocation = "3560v2/config/"
backupName = "3560v2.cfg"
backupInit = "copy running-config tftp:"

# backup init
print("               Config Backup               ")
print("--------------------------------------------")
connect.send_command_timing(backupInit)

# tftp server ip input
print("Connecting to TFTP Server...")
connect.send_command_timing(tftpServerIp)

# backup file name
print("Searching for Backup Location...")
connect.send_command_timing(backuplocation + backupName)

# final confirm to overwrite original file and disonnecting
print("Overwriting...")
connect.send_command_timing('\n')
connect.disconnect()

print("Upload Successfull!")
