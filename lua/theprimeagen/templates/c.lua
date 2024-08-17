local module = {};

module.c_template = [[
#include"stdio.h"
#include"stdlib.h"
#include"stdint.h"

int32_t main(void) {
    int32_t return_value = 0;
    
    return return_value;
}]]

function module.insert_c_template()
    local ft = vim.bo.filetype;
    if ft == 'c' then
         vim.api.nvim_put(vim.split(module.c_template, '\n'), 'l', false, false)
   else 
        print("This template is only for c files.");
    end
end

return module;
