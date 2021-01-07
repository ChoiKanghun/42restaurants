/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   exec_export_backslash.c                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:12:32 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:12:33 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

int		count_car_and_backslash(char *output_str, char *input_str)
{
	int str_count;
	int car_count;

	str_count = 0;
	car_count = 0;
	while (input_str[str_count])
	{
		if (input_str[str_count] == '\\')
			car_count += 2;
		else
			car_count++;
		str_count++;
	}
	car_count += ft_strlen(output_str);
	return (car_count);
}

int		add_double_backslash(char *final_str, int final_count)
{
	ft_strcat(final_str, "\\\\");
	final_count += 2;
	return (final_count);
}

int		copy_car(char *final_str, char car, int final_count)
{
	final_str[final_count] = car;
	final_count++;
	return (final_count);
}

char	*transform_backslash(char *output_str, char *input_str)
{
	int		final_count;
	int		in_count;
	int		car_count;
	char	*final_str;

	final_count = ft_strlen(output_str);
	in_count = 0;
	car_count = count_car_and_backslash(output_str, input_str);
	if (!(final_str = (char *)malloc(sizeof(char) * (car_count + 2))))
		ft_error('\0', "Malloc", NULL, 1);
	ft_strcpy(final_str, output_str);
	while (input_str[in_count])
	{
		if (input_str[in_count] == '\\')
			final_count = add_double_backslash(final_str
			, final_count);
		else
			final_count = copy_car(final_str
			, input_str[in_count], final_count);
		in_count++;
	}
	final_str[final_count] = '\0';
	free_str(&output_str);
	return (final_str);
}
