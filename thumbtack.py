import sys


class SimpleDatabase():
	def __init__(self):
		self.database = {}
		self.stack = []

	def write(self, name, value):
		if value == none:
			del self.database[name]
		else:
			self.database[name] = value
		
	def begin(self):
		self.stack.insert(0,{})
	def rollback(self):
		if self.stack:
			for key in self.stack:
				self.write(key,self.stack[key])
			self.stack.pop(0)

	def set(self, name, value):
		if self.stack:
			if name in self.database and 	
		
			if name not in self.database

		self.write(name,value)
	def get(self, name):
		pass
	def unset(self, name):
		pass
	def numequalto(self, value):
		pass




def main():
	database = SimpleDatabase
	input_line = sys.stdin.readline().strip()

	while input_line!= 'END':
		args = input_line.split(' ')

		command = args[0]


		if command == 'BEGIN':
			database.begin()
		elif command == 'ROLLBACK':
			pass
		elif command == 'COMMIT':
			pass
		elif command == 'SET':
			pass
		elif command == 'GET':
			pass
		elif command == 'UNSET':
			pass
		else:
			print "Invalid command"

		input_line = sys.stdin.readline().strip()


main()
