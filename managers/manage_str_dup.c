/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   manage_str_dup.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:37:12 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:37:14 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/exec.h"

char	*ft_strcpy(char *dest, char *src)
{
	int count;

	count = 0;
	while (src[count] != '\0')
	{
		dest[count] = src[count];
		count++;
	}
	dest[count] = '\0';
	return (dest);
}

char	*ft_strncpy(char *dest, char *src, unsigned int limit)
{
	unsigned int count;

	count = 0;
	while (src[count] != '\0' && count < limit)
	{
		dest[count] = src[count];
		count++;
	}
	dest[count] = '\0';
	while (count < limit)
	{
		dest[count] = '\0';
		count++;
	}
	return (dest);
}

char	*ft_strcat(char *dest, char *src)
{
	int dest_count;
	int src_count;

	dest_count = 0;
	src_count = 0;
	while (dest[dest_count] != '\0')
		dest_count++;
	while (src[src_count] != '\0')
	{
		dest[dest_count] = src[src_count];
		dest_count++;
		src_count++;
	}
	dest[dest_count] = '\0';
	return (dest);
}

char	*ft_strncat(char *dest, char *src, unsigned int limit)
{
	unsigned int dest_count;
	unsigned int src_count;

	dest_count = 0;
	src_count = 0;
	while (dest[dest_count] != '\0')
		dest_count++;
	while (src[src_count] != '\0' && src_count < limit)
	{
		dest[dest_count] = src[src_count];
		dest_count++;
		src_count++;
	}
	dest[dest_count] = '\0';
	return (dest);
}

char	*ft_strdup(const char *input_str)
{
	int		count;
	int		str_size;
	char	*output_str;

	count = 0;
	str_size = ft_strlen(input_str);
	if (!(output_str = malloc(sizeof(char) * (str_size + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	if (output_str == NULL)
		return (0);
	while (count < str_size)
	{
		output_str[count] = input_str[count];
		count++;
	}
	output_str[count] = '\0';
	return (output_str);
}
