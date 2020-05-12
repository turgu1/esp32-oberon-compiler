(*
// Copyright 2015-2016 Espressif Systems (Shanghai) PTE LTD
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
*)

MODULE [CDECL] ESP_System;

  IMPORT s := ESP_Support, e := ESP_Error;

  CONST
    (* typedef enum esp_mac_type_t *)
    ESP_MAC_WIFI_STA*    =  0; (* wifi station *)
    ESP_MAC_WIFI_SOFTAP* =  1; (* wifi softap *)
    ESP_MAC_BT*          =  2; (* bluetooth *)
    ESP_MAC_ETH*         =  3; (* ethernet *)

    (* typedef enum esp_reset_reason_t *)
    ESP_RST_UNKNOWN*     =  0; (* Reset reason can not be determined *)
    ESP_RST_POWERON*     =  1; (* Reset due to power-on event *)
    ESP_RST_EXT*         =  2; (* Reset by external pin (not applicable for ESP32) *)
    ESP_RST_SW*          =  3; (* Software reset via esp_restart *)
    ESP_RST_PANIC*       =  4; (* Software reset due to exception/panic *)
    ESP_RST_INT_WDT*     =  5; (* Reset (software or hardware) due to interrupt watchdog *)
    ESP_RST_TASK_WDT*    =  6; (* Reset due to task watchdog *)
    ESP_RST_WDT*         =  7; (* Reset due to other watchdogs *)
    ESP_RST_DEEPSLEEP*   =  8; (* Reset after exiting deep sleep mode *)
    ESP_RST_BROWNOUT*    =  9; (* Brownout reset (software or hardware) *)
    ESP_RST_SDIO*        = 10; (* Reset over SDIO *)

    (* typedef enum esp_chip_model_t *)
    CHIP_ESP32*          =  1; (* ESP32 *)
    CHIP_ESP32S2*        =  2; (* ESP32-S2 NOT SUPPORTED BY OberonESP32... *)

    (* Chip feature flags, used in esp_chip_info_t (SET) *)
    CHIP_FEATURE_EMB_FLASH = 0; (* Chip has embedded flash memory *)
    CHIP_FEATURE_WIFI_BGN  = 1; (* Chip has 2.4GHz WiFi *)
    CHIP_FEATURE_BLE       = 4; (* Chip has Bluetooth LE *)
    CHIP_FEATURE_BT        = 5; (* Chip has Bluetooth Classic *)

  TYPE 
    (**
     * Shutdown handler type
     *)
    shutdown_handler_t* = PROCEDURE ();

    (**
     * @brief The structure represents information about the chip
     *)
    esp_chip_info_t* = RECORD
      model*:    s.enum_t;  (* esp_chip_model_t: chip model, one of esp_chip_model_t *)
      features*: SET;       (* bit mask of CHIP_FEATURE_x feature flags *)
      cores*:    BYTE;      (* number of CPU cores *)
      revision*: BYTE       (* chip revision number *)
    END ;
   
  (**
   * @brief  Register shutdown handler
   *
   * This function allows you to register a handler that gets invoked before
   * the application is restarted using esp_restart function.
   * @param handle function to execute on restart
   * @return
   *   - ESP_OK on success
   *   - ESP_ERR_INVALID_STATE if the handler has already been registered
   *   - ESP_ERR_NO_MEM if no more shutdown handler slots are available
   *)  
  PROCEDURE esp_register_shutdown_handler* (handle: shutdown_handler_t): e.esp_err_t;

  (**
   * @brief  Unregister shutdown handler
   *
   * This function allows you to unregister a handler which was previously
   * registered using esp_register_shutdown_handler function.
   *   - ESP_OK on success
   *   - ESP_ERR_INVALID_STATE if the given handler hasn't been registered before
   *)
  PROCEDURE esp_unregister_shutdown_handler* (handle: shutdown_handler_t): e.esp_err_t;

  (**
   * @brief  Restart PRO and APP CPUs.
   *
   * This function can be called both from PRO and APP CPUs.
   * After successful restart, CPU reset reason will be SW_CPU_RESET.
   * Peripherals (except for WiFi, BT, UART0, SPI1, and legacy timers) are not reset.
   * This function does not return.
   *)
  PROCEDURE esp_restart* ();

  (**
   * @brief  Get reason of last reset
   * @return See description of esp_reset_reason_t for explanation of each value.
   *)
  PROCEDURE esp_reset_reason* (): s.enum_t;

  (**
   * @brief  Get the size of available heap.
   *
   * Note that the returned value may be larger than the maximum contiguous block
   * which can be allocated.
   *
   * @return Available heap size, in bytes.
   *)
  PROCEDURE esp_get_free_heap_size* (): INTEGER;

  (**
   * @brief Get the minimum heap that has ever been available
   *
   * @return Minimum free heap ever available
   *)
  PROCEDURE esp_get_minimum_free_heap_size* (): INTEGER;

  (**
   * @brief  Get one random 32-bit word from hardware RNG
   *
   * The hardware RNG is fully functional whenever an RF subsystem is running (ie Bluetooth or WiFi is enabled). For
   * random values, call this function after WiFi or Bluetooth are started.
   *
   * If the RF subsystem is not used by the program, the function bootloader_random_enable() can be called to enable an
   * entropy source. bootloader_random_disable() must be called before RF subsystem or I2S peripheral are used. See these functions'
   * documentation for more details.
   *
   * Any time the app is running without an RF subsystem (or bootloader_random) enabled, RNG hardware should be
   * considered a PRNG. A very small amount of entropy is available due to pre-seeding while the IDF
   * bootloader is running, but this should not be relied upon for any use.
   *
   * @return Random value between 0 and UINT32_MAX
   *)
  PROCEDURE esp_random* (): INTEGER;

  (**
   * @brief Fill a buffer with random bytes from hardware RNG
   *
   * @note This function has the same restrictions regarding available entropy as esp_random()
   *
   * @param buf Pointer to buffer to fill with random numbers.
   * @param len Length of buffer in bytes
   *)
  PROCEDURE esp_fill_random* (VAR buf: s.bytes_t; len: s.size_t);

  (**
   * @brief  Set base MAC address with the MAC address which is stored in BLK3 of EFUSE or
   *         external storage e.g. flash and EEPROM.
   *
   * Base MAC address is used to generate the MAC addresses used by the networking interfaces.
   * If using base MAC address stored in BLK3 of EFUSE or external storage, call this API to set base MAC
   * address with the MAC address which is stored in BLK3 of EFUSE or external storage before initializing
   * WiFi/BT/Ethernet.
   *
   * @note Base MAC must be a unicast MAC (least significant bit of first byte must be zero).
   *
   * @note If not using a valid OUI, set the "locally administered" bit
   *       (bit value 0x02 in the first byte) to avoid collisions.
   *
   * @param  mac  base MAC address, length: 6 bytes.
   *
   * @return ESP_OK on success
   *         ESP_ERR_INVALID_ARG If mac is NULL or is not a unicast MAC
   *)
  PROCEDURE esp_base_mac_addr_set* (mac: s.mac_t): e.esp_err_t;

  (**
   * @brief  Return base MAC address which is set using esp_base_mac_addr_set.
   *
   * @param  mac  base MAC address, length: 6 bytes.
   *
   * @return ESP_OK on success
   *         ESP_ERR_INVALID_MAC base MAC address has not been set
   *)
  PROCEDURE esp_base_mac_addr_get* (VAR mac: s.mac_t): e.esp_err_t;

  (**
   * @brief  Return base MAC address which was previously written to BLK3 of EFUSE.
   *
   * Base MAC address is used to generate the MAC addresses used by the networking interfaces.
   * This API returns the custom base MAC address which was previously written to BLK3 of EFUSE.
   * Writing this EFUSE allows setting of a different (non-Espressif) base MAC address. It is also
   * possible to store a custom base MAC address elsewhere, see esp_base_mac_addr_set() for details.
   *
   * @param  mac  base MAC address, length: 6 bytes.
   *
   * @return ESP_OK on success
   *         ESP_ERR_INVALID_VERSION An invalid MAC version field was read from BLK3 of EFUSE
   *         ESP_ERR_INVALID_CRC An invalid MAC CRC was read from BLK3 of EFUSE
   *)
  PROCEDURE esp_efuse_mac_get_custom* (VAR mac: s.mac_t): e.esp_err_t;

  (**
   * @brief  Return base MAC address which is factory-programmed by Espressif in BLK0 of EFUSE.
   *
   * @param  mac  base MAC address, length: 6 bytes.
   *
   * @return ESP_OK on success
   *)
  PROCEDURE esp_efuse_mac_get_default* (VAR mac: s.mac_t): e.esp_err_t;

  (**
   * @brief  Read base MAC address and set MAC address of the interface.
   *
   * This function first get base MAC address using esp_base_mac_addr_get or reads base MAC address
   * from BLK0 of EFUSE. Then set the MAC address of the interface including wifi station, wifi softap,
   * bluetooth and ethernet.
   *
   * @param  mac  MAC address of the interface, length: 6 bytes.
   * @param  type  type of MAC address, 0:wifi station, 1:wifi softap, 2:bluetooth, 3:ethernet.
   *
   * @return ESP_OK on success
   *)
  PROCEDURE esp_read_mac* (VAR mac: s.mac_t; type: s.enum_t): e.esp_err_t;

  (**
   * @brief Derive local MAC address from universal MAC address.
   *
   * This function derives a local MAC address from an universal MAC address.
   * A `definition of local vs universal MAC address can be found on Wikipedia
   * <https://en.wikipedia.org/wiki/MAC_address#Universal_vs._local>`.
   * In ESP32, universal MAC address is generated from base MAC address in EFUSE or other external storage.
   * Local MAC address is derived from the universal MAC address.
   *
   * @param  local_mac  Derived local MAC address, length: 6 bytes.
   * @param  universal_mac  Source universal MAC address, length: 6 bytes.
   *
   * @return ESP_OK on success
   *)
  PROCEDURE esp_derive_local_mac* (VAR local_mac: s.mac_t; universal_mac: s.mac_t): e.esp_err_t;

  (**
   * @brief Trigger a software abort
   * 
   * @param details Details that will be displayed during panic handling.
   *)
  PROCEDURE esp_system_abort* (details: s.str_t);

  (**
   * @brief Fill an esp_chip_info_t structure with information about the chip
   * @param[out] out_info structure to be filled
   *)
  PROCEDURE esp_chip_info* (VAR out_info: esp_chip_info_t);

END ESP_System.