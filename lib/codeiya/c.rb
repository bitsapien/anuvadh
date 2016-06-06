module Codeiya
	module Writer
		class C
			class << self
				def write data
					@name = data['name']
					@comments =  data['comments']
					@variables =  data['variables']
					@namespace =  data['namespace']
					the_file = create_files data['name'], data['namespace']

					var_input_list = Codeiya::Variables.aggregate @variables["input"]
					var_output_list = Codeiya::Variables.aggregate @variables["output"]

					create_extra_variables_if_needed(var_input_list+var_output_list)

					var_extra = Codeiya::Variables.aggregate @variables["extra"]


					code = "// Name : #{@name}\n"
					code << "#include <stdio.h>\nint main() {\n"
					code << "\t// input:\n"
					@comments['top'].split("\n").each do |comment|
						code << "\t// #{comment}\n"
					end
					code << "#{variables_define((var_input_list+var_output_list+var_extra))}"

					code << "#{input_lines(var_input_list)}"

					code << "\n\n\t// write your code here\n"

					@comments['middle'].split("\n").each do |comment|
						code << "\t// #{comment}\n"
					end

					code << "\n\t// output\n"

					@comments['bottom'].split("\n").each do |comment|
						code << "\t// #{comment}\n"
					end

					code << "#{output_lines(var_output_list)}"

					code << "\treturn 0;"

					code << "\n}"

					File.open(the_file, 'wb') { |file| file.write(code) }

				end

				def create_extra_variables_if_needed var_list 
					extra = []
					var_list.each do |var|
						if var['size1'].blank? & var['size2'].blank?
						elsif var['size2'].blank?
							extra.push '<integer>index'
						else
							extra.push '<integer>idx'
							extra.push '<integer>jdx'
						end
					end
					tmp_extra = @variables['extra'].split(' ')
					@variables['extra'] = (extra+tmp_extra).join(' ')

				end

				def create_files name, namespace
					path = File.join('public', namespace, 'C')
					unless File.directory? path
						Dir.mkdir(path)
					end
					filename = "#{name.parameterize}.c"	
					File.join(path,filename)			
				end


				def variables_define variable_set
					# data types
					data_type = {
						'int' => 'int',
						'string' => 'char',
						'float' => 'float',
						'double' => 'double'
					}
					vd = ''
					(variable_set.group_by {|d| d['type']}).each do |d_t,d|
						definition = "#{data_type[d_t]} "
						list = []
						d.each do |vr|
							if vr['size1'].empty? && vr['size2'].empty?
								if vr['value'].blank?
									list.push vr['name'].to_s
								else
									list.push "#{vr['name'].to_s}=#{vr['value']}" if vr['type'].in? ['int', 'float', 'double']
									list.push "#{vr['name'].to_s}=\'#{vr['value']}\'" if vr['type'].in? ['char', 'string']
								end
							elsif vr['size2'].empty?
								list.push "#{vr['name'].to_s}[#{vr['size1']}]"
							else
								list.push "#{vr['name'].to_s}[#{vr['size1']}][#{vr['size2']}]"
							end
						end
						vd << "\t#{definition}#{list.join(', ')};\n"
					end
					vd
				end

				def input_lines input_list
					# detect positions
					input_code = ''
					x = input_list.map do |ex| ex['x'] end
					number_of_lines = x.max + 1
					number_of_lines.times do |idx|
						index = idx - 1
						one_line = (input_list.map do |n| n if n['x']==idx end).compact
						input_code << input_interpreter(one_line)
					end
					input_code
				end

				def input_interpreter sublist
					access_specifier_mappings = {
						'char' => '%c',
						'int' => '%d',
						'string' => '%s',
						'float' => '%f'
					}
					input_code = ''
					access_specifier_string = []
					input_variables_string = []
					sublist.each do |one|
						if one['size1'].blank? && one['size2'].blank?
							access_specifier_string.push access_specifier_mappings[one['type']]
							input_variables_string.push "&#{one['name']}"
						elsif one['size2'].blank?

						else
							
						end
						input_code << "\tscanf(\"#{access_specifier_string.join(' ')}\", #{input_variables_string.join(', ')});\n"
					end
					input_code
				end

				def output_lines output_list
					# detect positions
					output_code = ''
					x = output_list.map do |ex| ex['x'] end
					number_of_lines = x.max + 1
					number_of_lines.times do |idx|
						index = idx - 1
						one_line = (output_list.map do |n| n if n['x']==idx end).compact
						output_code << output_interpreter(one_line)
					end
					output_code
				end

				def output_interpreter sublist
					access_specifier_mappings = {
						'char' => '%c',
						'int' => '%d',
						'string' => '%s',
						'float' => '%f'
					}
					access_specifier_string = []
					output_variables_string = []
					sublist.each do |one|
						if one['size1'].blank? && one['size2'].blank?
							access_specifier_string.push access_specifier_mappings[one['type']]
							output_variables_string.push "#{one['name']}"
						elsif one['size2'].blank?

						else

						end
					end
					"\tprintf(\"#{access_specifier_string.join(' ')}\", #{output_variables_string.join(', ')});\n"
				end

			end




		end
	end
end