#!/bin/sh

modify_service_conf() {
  modify_service_conf_file="$1"
  modify_service_conf_linePrefix="$2"
  modify_service_conf_subcommand="$3"
  modify_service_conf_flag="$4"

  # Escape characters that have special meaning in regular expressions
  modify_service_conf_flag_escaped=$(echo "${modify_service_conf_flag}" | sed -e 's/[]\/$*.^|[]/\\&/g')

  if [ ! -f "${modify_service_conf_file}" ]; then
    exit 1
  fi

  modify_service_conf_new_content=""
  modify_service_conf_found=0

  while IFS= read -r modify_service_conf_line || [ -n "$modify_service_conf_line" ]; do
    if echo "${modify_service_conf_line}" | grep -q "^${modify_service_conf_linePrefix}"; then
      modify_service_conf_found=1
      case "${modify_service_conf_subcommand}" in
        add)
          if ! echo "${modify_service_conf_line}" | grep -qw "${modify_service_conf_flag}"; then
            modify_service_conf_line="${modify_service_conf_linePrefix} ${modify_service_conf_flag} ${modify_service_conf_line#${#modify_service_conf_linePrefix}}"
          fi
          ;;
        del|delete)
          modify_service_conf_line=$(echo "${modify_service_conf_line}" | sed "s/\\b${modify_service_conf_flag_escaped}\\b//g")
          ;;
        *)
          ;;
      esac
    fi
    modify_service_conf_new_content=$(printf "%s\n%s" "${modify_service_conf_new_content}" "${modify_service_conf_line}")
  done < "${modify_service_conf_file}"

  if [ "${modify_service_conf_found}" -eq 0 ]; then
    exit 1
  fi

  printf "%s" "${modify_service_conf_new_content}" > "${modify_service_conf_file}"
}

modify_service_conf "/etc/systemd/system/getty@tty1.service.d/autologin.conf" "ExecStart=-/sbin/agetty" "del" "--skip-login"
modify_service_conf "/etc/systemd/system/getty@tty1.service.d/autologin.conf" "ExecStart=-/sbin/agetty" "del" "--nonewline"
