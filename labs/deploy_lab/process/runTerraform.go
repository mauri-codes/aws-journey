package process

import (
	"bytes"
	"fmt"
	"os/exec"
)

func RunCommand(dir string, mainCommand string, command ...string) error {
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
		return fmt.Errorf("error running: "+stringCommand+", %w", err)
	}
	fmt.Println(out.String())
	return nil
}

func TerraformCommand(action string, labId string) error {
	if action == APPLY_ACTION {
		action = "apply"
	} else {
		action = "destroy"
	}
	dir := "../" + labId + "/iac"
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
