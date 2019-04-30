<?php
/**
 * Router
 */

/**
 * トップ @TODO インストール設定時の状態 修正予定
 *
 */
Route::get('/', function () {
	return view('welcome');
});

/**
 * Web API Routes
 * @NOTE /api/{コントローラ名}/{メソッド名}/・・・で記載すること
 */
// デバイス操作時刻CRUD
Route::match(['get', 'post'], '/api/device-operate-time/select', 'Api\DeviceOperateTimeController@select');  // 参照
Route::match(['get', 'post'], '/api/device-operate-time/add',    'Api\DeviceOperateTimeController@add');     // 追加
Route::match(['get', 'post'], '/api/device-operate-time/update', 'Api\DeviceOperateTimeController@update');  // 更新
Route::match(['get', 'post'], '/api/device-operate-time/delete', 'Api\DeviceOperateTimeController@delete');  // 削除
//
