# Import math Library
import math

def float_bin(number, places = 3): 
  	
  	aux = str(number)

  	whole, dec = aux.split(".")

  	whole = int(whole)
  	dec = int(dec)

  	res = bin(whole).lstrip("0b") + "."

  	for x in range(places):

  		temp_1 = ((decimal_converter(dec)) * 2)
  		temp = str(temp_1)
  		if temp_1 != 0:
  			whole, dec = temp.split(".")
  		else:
  			whole = temp
  		dec = int(dec)
  		res += whole

  	return res

def decimal_converter(num):  
    while num > 1: 
        num /= 10
    return num 

y = 0.00

# Return the base-2 logarithm of different numbers
for x in range(255):
	y = math.log2(x+1)
	y = round(y,5);
	y = (float_bin(y, places = 5))
	
	if x == 0:
		with open ("tabela_log2.txt", "w") as arquivo:
			arquivo.write (y)
	else:
		with open ("tabela_log2.txt", "a") as arquivo:
			arquivo.write ("\n")
			arquivo.write (y)
