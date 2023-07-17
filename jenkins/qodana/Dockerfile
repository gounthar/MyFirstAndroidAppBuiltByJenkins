FROM jetbrains/qodana-jvm-android:2023.2-eap as qodana

# Second . because of WORKDIR cf. https://hub.docker.com/layers/jetbrains/qodana-jvm-android/2022.2-eap/images/sha256-472c68dc8ef30caf45a1664ee5d2d27c868a8090985545d1f958469a6b416f09?context=explore
COPY . .
RUN qodana --save-report

FROM scratch AS export-stage
COPY --from=qodana /data/results /

