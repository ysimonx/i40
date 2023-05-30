/*

  // cf https://github.com/red-star25/dio_blog/tree/main/lib/data/repository
  // cf https://dhruvnakum.xyz/networking-in-flutter-dio

  CloudServer cs = CloudServer.fromJson({
    "serverURL": "https://cloud.kysoe.com",
    "provisionDeviceKey": "a",
    "provisionDeviceSecret": "b"
  });

*/

class CloudServer {
  String? serverURL;
  String? provisionDeviceKey;
  String? provisionDeviceSecret;

  CloudServer(
      {this.serverURL, this.provisionDeviceKey, this.provisionDeviceSecret});

  CloudServer.fromJson(Map<String, dynamic> json) {
    serverURL = json['serverURL'];
    provisionDeviceKey = json['provisionDeviceKey'];
    provisionDeviceSecret = json['provisionDeviceSecret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverURL'] = this.serverURL;
    data['provisionDeviceKey'] = this.provisionDeviceKey;
    data['provisionDeviceSecret'] = this.provisionDeviceSecret;
    return data;
  }
}

class Device {
  String? deviceName;
  ProvisioningResponse? provisioningResponse;

  Device({this.deviceName, this.provisioningResponse});

  Device.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    provisioningResponse = json['provisioningResponse'] != null
        ? ProvisioningResponse.fromJson(json['provisioningResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    if (provisioningResponse != null) {
      data['provisioningResponse'] = provisioningResponse!.toJson();
    }
    return data;
  }
}

class GatewayDevice extends Device {
  bool? isGateway = true;

  GatewayDevice() : super();

  GatewayDevice.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    isGateway = true;
    provisioningResponse = json['provisioningResponse'] != null
        ? ProvisioningResponse.fromJson(json['provisioningResponse'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data['isGateway'] = isGateway;
    return data;
  }
}

class ProvisioningResponse {
  String? status;
  String? credentialsType;
  String? credentialsValue;

  ProvisioningResponse(
      {this.status, this.credentialsType, this.credentialsValue});

  ProvisioningResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    credentialsType = json['credentialsType'];
    credentialsValue = json['credentialsValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['credentialsType'] = credentialsType;
    data['credentialsValue'] = credentialsValue;
    return data;
  }
}
