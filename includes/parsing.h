#ifndef PARSING_H
# define PARSING_H

# include "./struct.h"

/*
** 		clear_it/clear_before_exec.c
*/
char	*clear_it(char *str);

/*
**		clear_it/clear_before_exec_2.c
*/
int		count_valid_str(char **input_array);
void	clear_tab(char ***pt_tab);
void	clear_str(char **pt_str);

/*
**		clear_it/clear_stock_rd.c
*/
char	*clear_stock_rd(char *str);

/*
**		parsing/check.c
*/
void	check(char *line);
void	check_rdc(char *str, char *map);
void	check_rdo(char *str, char *map);

/*
**		parsing/list_utils.c
*/
t_list	*new_lst(void);
int		is_empty_lst();

/*
**      parsing/list_utils_2.c
*/
int		is_only_space(char *stock);
int		is_pipe(char *stock);

/*
**      parsing/list_it.c
*/
void	list_it(char **stock);

/*
**      parsing/get_dollar_2.c
*/
char	*get_startline(char *str, int j);
char	*get_endline(char *str, int j);
char	*get_env_name_2check(char *str, int j);
t_value	new_value(char *str, int j);
char	*get_env_value_2(char *str, int j);

/*
**		parsing/get_redir.c
*/
t_cont	get_redir(char *str);
int		find_rdc(char *str);
int		is_rdc(char *str, int i);
int		count_rdc(char *str);

/*
**		parsing/get_redir_2.c
*/
void	get_rd_index(char *str, int **rdc_index, int **rdo_index, char *g_map);
int		**create_index_array(char *str, char *type);
int		get_rdc_type(char *str);

/*
**		parsing/get_rdo.c
*/
char	**get_rdo_filetab(char *str);
int		find_rdo(char *str);
int		count_rdo(char *str);

/*
**		parsing/utils_2.c
*/
int		is_name(char *str, int i);
char	*get_name(char *str, int i, int ret);
char	*get_rdc_name(char *str, int i);
char	**get_rdc_filetab(char *str);
char	*get_last(char **tab);

/*
**		parsing/utils_3.c
*/
int		ft_envcmp(char *s1, char *s2);
int		is_env(char *str, int j);
int		quote_stop(char *str, int j);
int		is_end_var_name(char *str, int i);
int		ft_strlen_null(const char *str);
int		except_case(char *str, int i);

/*
**		parsing/split_plus.c
*/
char	**split_plus(char *str, char charset);

#endif
