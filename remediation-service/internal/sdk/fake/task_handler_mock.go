// Code generated by moq; DO NOT EDIT.
// github.com/matryer/moq

package fake

import (
	"github.com/keptn/keptn/remediation-service/internal/sdk"
	"sync"
)

// Ensure, that TaskHandlerMock does implement sdk.TaskHandler.
// If this is not the case, regenerate this file with moq.
var _ sdk.TaskHandler = &TaskHandlerMock{}

// TaskHandlerMock is a mock implementation of sdk.TaskHandler.
//
// 	func TestSomethingThatUsesTaskHandler(t *testing.T) {
//
// 		// make and configure a mocked sdk.TaskHandler
// 		mockedTaskHandler := &TaskHandlerMock{
// 			ExecuteFunc: func(keptnHandle sdk.IKeptn, data interface{}) (interface{}, *sdk.Error) {
// 				panic("mock out the Execute method")
// 			},
// 			InitDataFunc: func() interface{} {
// 				panic("mock out the InitData method")
// 			},
// 		}
//
// 		// use mockedTaskHandler in code that requires sdk.TaskHandler
// 		// and then make assertions.
//
// 	}
type TaskHandlerMock struct {
	// ExecuteFunc mocks the Execute method.
	ExecuteFunc func(keptnHandle sdk.IKeptn, data interface{}) (interface{}, *sdk.Error)

	// InitDataFunc mocks the InitData method.
	InitDataFunc func() interface{}

	// calls tracks calls to the methods.
	calls struct {
		// Execute holds details about calls to the Execute method.
		Execute []struct {
			// KeptnHandle is the keptnHandle argument value.
			KeptnHandle sdk.IKeptn
			// Data is the data argument value.
			Data interface{}
		}
		// InitData holds details about calls to the InitData method.
		InitData []struct {
		}
	}
	lockExecute  sync.RWMutex
	lockInitData sync.RWMutex
}

// Execute calls ExecuteFunc.
func (mock *TaskHandlerMock) Execute(keptnHandle sdk.IKeptn, data interface{}) (interface{}, *sdk.Error) {
	if mock.ExecuteFunc == nil {
		panic("TaskHandlerMock.ExecuteFunc: method is nil but TaskHandler.Execute was just called")
	}
	callInfo := struct {
		KeptnHandle sdk.IKeptn
		Data        interface{}
	}{
		KeptnHandle: keptnHandle,
		Data:        data,
	}
	mock.lockExecute.Lock()
	mock.calls.Execute = append(mock.calls.Execute, callInfo)
	mock.lockExecute.Unlock()
	return mock.ExecuteFunc(keptnHandle, data)
}

// ExecuteCalls gets all the calls that were made to Execute.
// Check the length with:
//     len(mockedTaskHandler.ExecuteCalls())
func (mock *TaskHandlerMock) ExecuteCalls() []struct {
	KeptnHandle sdk.IKeptn
	Data        interface{}
} {
	var calls []struct {
		KeptnHandle sdk.IKeptn
		Data        interface{}
	}
	mock.lockExecute.RLock()
	calls = mock.calls.Execute
	mock.lockExecute.RUnlock()
	return calls
}

// InitData calls InitDataFunc.
func (mock *TaskHandlerMock) InitData() interface{} {
	if mock.InitDataFunc == nil {
		panic("TaskHandlerMock.InitDataFunc: method is nil but TaskHandler.InitData was just called")
	}
	callInfo := struct {
	}{}
	mock.lockInitData.Lock()
	mock.calls.InitData = append(mock.calls.InitData, callInfo)
	mock.lockInitData.Unlock()
	return mock.InitDataFunc()
}

// InitDataCalls gets all the calls that were made to InitData.
// Check the length with:
//     len(mockedTaskHandler.InitDataCalls())
func (mock *TaskHandlerMock) InitDataCalls() []struct {
} {
	var calls []struct {
	}
	mock.lockInitData.RLock()
	calls = mock.calls.InitData
	mock.lockInitData.RUnlock()
	return calls
}
