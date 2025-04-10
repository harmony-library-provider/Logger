import { SafeWriteFileOutput } from 'logger'
import { SafeConsoleOutput } from 'logger'
import { SafeMultiOutput } from 'logger'
import { logger } from 'logger'


@Entry
@Component
struct Index {
  async print(message: ESObject) {
    logger.reset({
      output: new SafeMultiOutput([
        new SafeWriteFileOutput({
          storage: 'logger/output/cache',
          fileFormatter: 'cache.[yyyyMMdd]',
          filePrefix: 'test-',
          fileSuffix: 'txt'
        }),
        new SafeConsoleOutput()
      ])
    })

    // logger.warn
    await logger.warn(message)

    // readAsString start
    const string = await logger.readAsString()

    if (string) {
      // readAsString success
    }

    // readAsArrayBuffer start
    const buffer = await logger.readAsArrayBuffer()

    if (buffer) {
      // readAsArrayBuffer success
    }

    // readAsRequestFile start
    const file = await logger.readAsRequestFile()

    if (file) {
      // readAsRequestFile success
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        Row()
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .height(56)
        .width(56)

        Row() {
          Text('Logger')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .fontColor(0x303133)
            .fontSize(18)
            .maxLines(1)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .layoutWeight(1)
        .height(56)

        Row()
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .height(56)
          .width(56)
      }
      .height(56)
      .width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Column() {
        Column() {
          Text('Click: Run logger.warn')
            .onClick(() => this.print('Start logger.warn: testing...'))
            .padding({ top: 4, left: 8, right: 8, bottom: 4 })
            .fontWeight(FontWeight.Medium)
            .fontColor(0x606266)
            .fontSize(16)
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 100, left: 30, right: 30, bottom: 30 })
      .margin({ top: 56 })
      .width('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(Color.White)
    .height('100%')
    .width('100%')
  }
}

