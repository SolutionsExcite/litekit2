Software comes as is.  I may start further development.  If so, I will update this README.md appropriately.

This shows the example Resnet18 .rknn model usage.  It is up to the developer to find appropriate output return structure from inference.

Of note:  This dockerfile takes special care to keep the system and virtual python environment in sync with python 3.10.  This is due to pip or conda install opencv does not provide updated packages and/or proper hardware support for the orange pi 5 plus.  Due to this, system wide packages for opencv are utilized in conjunction with the virtual environment to provide a semi independent python environment.


chmod +x run.sh
./run.sh


sudo docker run -it --rm --privileged litekit2
podman run -it --rm --privileged litekit2



Expected results when ran:
--> Load RKNN model
done
--> Init runtime environment
I RKNN: [05:29:16.500] RKNN Runtime Information, librknnrt version: 2.0.0b0 (35a6907d79@2024-03-24T10:31:14)
I RKNN: [05:29:16.500] RKNN Driver Information, version: 0.9.6
I RKNN: [05:29:16.501] RKNN Model Information, version: 6, toolkit version: 2.0.0b0+9bab5682(compiler version: 2.0.0b0 (35a6907d79@2024-03-24T02:34:11)), target: RKNPU v2, target platform: rk3588, framework name: PyTorch, framework layout: NCHW, model inference type: static_shape
done
--> Running model
resnet18
-----TOP 5-----
[812] score:0.999680 class:"space shuttle"
[404] score:0.000249 class:"airliner"
[657] score:0.000013 class:"missile"
[466] score:0.000009 class:"bullet train, bullet"
[895] score:0.000008 class:"warplane, military plane"

done