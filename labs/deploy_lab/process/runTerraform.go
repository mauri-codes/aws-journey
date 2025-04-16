package process

import (
	"bytes"
	custom_error "deploy_lab/errors"
	error_codes "deploy_lab/errors/errorCodes"
	"fmt"
	"os/exec"
)

func RunCommand(dir string, mainCommand string, command ...string) custom_error.ICustomError {
	completeCommand := mainCommand
	for _, subcommand := range command {
		completeCommand += " "
		completeCommand += subcommand
	}
	cmd := exec.Command(mainCommand, command...)
	cmd.Dir = dir
	var out bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	stringCommand := mainCommand
	for _, commandWord := range command {
		stringCommand = stringCommand + " " + commandWord
	}
	err := cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		return custom_error.NewCustomDetailedError(error_codes.TERRAFORM_COMMAND_FAILED, "Command Failed: "+completeCommand, stderr.String())
	}
	fmt.Println(out.String())
	return nil
}

func TerraformCommand(action string, labPath string) custom_error.ICustomError {
	if action == APPLY_ACTION {
		action = "apply"
	} else {
		action = "destroy"
	}
	dir := "../" + labPath + "/iac"
	err := RunCommand(dir, "terragrunt", "init")
	if err != nil {
		return err
	}
	err = RunCommand(dir, "terragrunt", action, "-auto-approve")
	if err != nil {
		return err
	}
	return nil
}
